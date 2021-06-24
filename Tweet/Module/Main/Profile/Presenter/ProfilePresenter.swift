//
//  ProfilePresenter.swift
//  Tweet
//
//  Created by addin on 21/06/21.
//

import Foundation
import Combine

class ProfilePresenter: ObservableObject {
  
  private var useCase: ProfileUseCase
  
  init(user: UserModel, useCase: ProfileUseCase) {
    self.user = user
    self.useCase = useCase
  }
  
  @Published var user: UserModel = UserModel()
  @Published var posts: [PostModel] = []
  
  @Published var isLoading = false
  @Published var followLoading = false
  @Published var isFollowing = false
  
  @Published var isError = false
  @Published var errorMessage = ""
  
  private var cancellables: Set<AnyCancellable> = []
  
  func getPosts() {
    self.isLoading = true
    self.isError = false
    self.errorMessage = ""
    useCase.getUserPosts(of: user.email)
      .sink { completion in
        switch completion {
        case .failure(let error):
          self.errorMessage = error.localizedDescription
          self.isError = true
          self.isLoading = false
        case .finished:
          self.isLoading = false
        }
      } receiveValue: { posts in
        self.posts = self.sortPosts(posts)
      }
      .store(in: &cancellables)
  }
  
  func follow(_ thisUser: UserModel) {
    self.followLoading = true
    self.isError = false
    self.errorMessage = ""
    useCase.follow(this: thisUser, for: user)
      .sink { completion in
        switch completion {
        case .failure(let error):
          self.errorMessage = error.localizedDescription
          self.isError = true
          self.followLoading = false
        case .finished:
          self.followLoading = false
          self.checkFollowStatus(thisUser)
        }
      } receiveValue: { _ in
      }
      .store(in: &cancellables)
  }
  
  func checkFollowStatus(_ thisUser: UserModel) {
    self.followLoading = true
    self.isError = false
    self.errorMessage = ""
    useCase.checkFollowStatus(this: thisUser, for: user)
      .sink { completion in
        switch completion {
        case .failure(let error):
          self.errorMessage = error.localizedDescription
          self.isError = true
          self.followLoading = false
        case .finished:
          self.followLoading = false
        }
      } receiveValue: { followValue in
        self.isFollowing = followValue
      }
      .store(in: &cancellables)
  }
  
  
  private func sortPosts(_ models: [PostModel]) -> [PostModel] {
    let count = 0..<models.count
    let dateFormatter = DateFormatter()
    
    dateFormatter.dateFormat = "dd/MM/yy HH:mm"
    
    var convertedArray: [(String, String, Date, UserModel)] = []
    
    for i in count {
      if let date =  dateFormatter.date(from: models[i].date) {
        convertedArray.append((models[i].id, models[i].text, date, models[i].user))
      }
    }
    
    let ready = convertedArray.sorted(by:  { $0.2.compare($1.2) == .orderedDescending })
    
    // formate the date to be more simple
    let dateFormatterGet = DateFormatter()
    dateFormatterGet.dateFormat = "dd/MM/yy HH:mm"
    let dateFormatterPrint = DateFormatter()
    dateFormatterPrint.dateFormat = "dd/MM/yy"
    
    let final = ready.map { item in
      return PostModel(id: item.0,
                       text: item.1,
                       date: Date().getFormattedDate(format: "dd/MM/yy") == dateFormatterPrint.string(from: dateFormatterGet.date(from: dateFormatterGet.string(from: item.2)) ?? Date()) ?
                        (dateFormatterGet.date(from: dateFormatterGet.string(from: item.2)) ?? Date()).getFormattedDate(format: "HH:mm") :
                        dateFormatterPrint.string(from: dateFormatterGet.date(from: dateFormatterGet.string(from: item.2)) ?? Date()),
                       user: item.3)
    }
    
    return final
  }
}
