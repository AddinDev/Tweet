//
//  SettingsUseCase.swift
//  Tweet
//
//  Created by addin on 18/06/21.
//

import Foundation
import Combine

protocol SettingsUseCaseProtocol {
  func signOut() -> AnyPublisher<Bool, Error>
  func checkFollowers() -> AnyPublisher<[UserModel], Error>
  func checkFollowing() -> AnyPublisher<[UserModel], Error>
}

class SettingsUseCase {
  
  private let repository: Repository
  init(repository: Repository) {
    self.repository = repository
  }
  
}

extension SettingsUseCase: SettingsUseCaseProtocol {
  
  func signOut() -> AnyPublisher<Bool, Error>{
    self.repository.signOut()
  }
  
  func checkFollowers() -> AnyPublisher<[UserModel], Error> {
    self.repository.checkFollowers()
  }
  
  func checkFollowing() -> AnyPublisher<[UserModel], Error> {
    self.repository.checkFollowing()
  }
  
}
