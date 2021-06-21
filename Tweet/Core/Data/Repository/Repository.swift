//
//  Repository.swift
//  Tweet
//
//  Created by addin on 16/06/21.
//

import Foundation
import Combine

protocol RepositoryProtocol {
  func signUp(username: String, email: String, password: String) -> AnyPublisher<Bool, Error>
  func signIn(email: String, password: String) -> AnyPublisher<Bool, Error>
  func signOut() -> AnyPublisher<Bool, Error>
  
  func getAllPosts() -> AnyPublisher<[PostModel], Error>
  func uploadPost(user: UserModel, text: String) -> AnyPublisher<Bool, Error>
  
  func follow(this currentUser: UserModel, for user: UserModel) -> AnyPublisher<Bool, Error>
}

final class Repository {
  
  typealias Repo = (RemoteDataSource) -> Repository
  fileprivate let remote: RemoteDataSource
  
  init(remote: RemoteDataSource) {
    self.remote = remote
  }
  
  static let sharedInstance: Repo = { remote in
    return Repository(remote: remote)
  }
  
}

extension Repository: RepositoryProtocol {
  
  func signUp(username: String, email: String, password: String) -> AnyPublisher<Bool, Error> {
    self.remote.signUp(username: username, email: email, password: password)
  }
  
  func signIn(email: String, password: String) -> AnyPublisher<Bool, Error> {
    self.remote.signIn(email: email, password: password)
  }
  
  func signOut() -> AnyPublisher<Bool, Error> {
    self.remote.signOut()
  }
  
  func getAllPosts() -> AnyPublisher<[PostModel], Error> {
    self.remote.getAllPosts()
      .map { PostMapper.postsResponseToModel(for: $0) }
      .eraseToAnyPublisher()
  }
  
  func uploadPost(user: UserModel, text: String) -> AnyPublisher<Bool, Error> {
    self.remote.uploadPost(user: user, text: text)
  }
  
  func follow(this currentUser: UserModel, for user: UserModel) -> AnyPublisher<Bool, Error> {
    self.remote.follow(this: currentUser, for: user)
  }
  
}
