//
//  HomePresenter.swift
//  Tweet
//
//  Created by addin on 16/06/21.
//

import SwiftUI
import Combine

class HomePresenter: ObservableObject {
  
  private var router = HomeRouter()
  
  private var useCase: HomeUseCase
  
  @Published var posts: [PostModel] = []
  @Published var isLoading = false
  @Published var isError = false
  @Published var errorMessage = ""
  
  private var cancellables: Set<AnyCancellable> = []

  
  init(useCase: HomeUseCase) {
    self.useCase = useCase
  }
  
  func makeUploadView() -> some View {
    self.router.makeUploadView()
  }
  
  func getPosts() {
    self.isLoading = true
    self.isError = false
    self.errorMessage = ""
    useCase.getFollowedPosts()
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
  
  func sortPosts(_ models: [PostModel]) -> [PostModel] {
    let count = 0..<models.count
    let dateFormatter = DateFormatter()
    
    dateFormatter.dateFormat = "dd/MM/yyyy "
    
    var convertedArray: [(String, String, Date, UserModel)] = []
    
    for i in count {
      if let date =  dateFormatter.date(from: models[i].date) {
        convertedArray.append((models[i].id, models[i].text, date, models[i].user))
      }
    }
    
    let ready = convertedArray.sorted(by:  { $0.2.compare($1.2) == .orderedDescending })
    
    let final = ready.map { item in
      return PostModel(id: item.0, text: item.1, date: dateFormatter.string(from: item.2), user: item.3)
    }

    return final
  }
  
}
