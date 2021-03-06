//
//  SearchUseCase.swift
//  Tweet
//
//  Created by addin on 17/06/21.
//

import Foundation
import Combine

protocol SearchUseCaseProtocol {
  func getAllPosts() -> AnyPublisher<[PostModel], Error>
  func searchUser(_ username: String) -> AnyPublisher<[UserModel], Error>
}

class SearchUseCase {
  
  private let repository: Repository
  init(repository: Repository) {
    self.repository = repository
  }
  
}

extension SearchUseCase: SearchUseCaseProtocol {
  
  func getAllPosts() -> AnyPublisher<[PostModel], Error> {
    self.repository.getAllPosts()
  }
  
  func searchUser(_ username: String) -> AnyPublisher<[UserModel], Error> {
    self.repository.searchUser(username)
  }
  
}
