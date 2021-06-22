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
        self.posts = posts
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
  
}
