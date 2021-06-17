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
  func getAllPosts() -> AnyPublisher<[PostModel], Error>
  func uploadPost(text: String) -> AnyPublisher<Bool, Error>
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
  
  func getAllPosts() -> AnyPublisher<[PostModel], Error> {
    self.remote.getAllPosts()
      .map { PostMapper.postsResponseToModel(for: $0) }
      .eraseToAnyPublisher()
  }
  
  func uploadPost(text: String) -> AnyPublisher<Bool, Error> {
    self.remote.uploadPost(text: text)
  }
  
}
