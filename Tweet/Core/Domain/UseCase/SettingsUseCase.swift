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
  
}
