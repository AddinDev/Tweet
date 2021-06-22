//
//  HomeUseCase.swift
//  Tweet
//
//  Created by addin on 17/06/21.
//

import Foundation
import Combine

protocol HomeUseCaseProtocol {
  func getFollowedPosts() -> AnyPublisher<[PostModel], Error>
}

class HomeUseCase {
  
  private let repository: Repository
  init(repository: Repository) {
    self.repository = repository
  }
  
}

extension HomeUseCase: HomeUseCaseProtocol {
  
  func getFollowedPosts() -> AnyPublisher<[PostModel], Error> {
    self.repository.getFollowedPosts()
  }
  
}
