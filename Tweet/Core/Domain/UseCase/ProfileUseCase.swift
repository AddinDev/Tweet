//
//  ProfileUseCase.swift
//  Tweet
//
//  Created by addin on 21/06/21.
//

import Foundation
import Combine

protocol ProfileUseCaseProtocol {
  func getUserPosts(of email: String) -> AnyPublisher<[PostModel], Error>
  func follow(this currentUser: UserModel, for user: UserModel) -> AnyPublisher<Bool, Error>
  func checkFollowStatus(this currentUser: UserModel, for user: UserModel) -> AnyPublisher<Bool, Error>
}

class ProfileUseCase {
  
  private let repository: Repository
  init(repository: Repository) {
    self.repository = repository
  }
  
}

extension ProfileUseCase: ProfileUseCaseProtocol {
  
  func getUserPosts(of email: String) -> AnyPublisher<[PostModel], Error> {
    self.repository.getUserPosts(of: email)
  }
  
  func follow(this currentUser: UserModel, for user: UserModel) -> AnyPublisher<Bool, Error> {
    self.repository.follow(this: currentUser, for: user)
  }
  
  func checkFollowStatus(this currentUser: UserModel, for user: UserModel) -> AnyPublisher<Bool, Error> {
    self.repository.checkFollowStatus(this: currentUser, for: user)
  }
  
}
