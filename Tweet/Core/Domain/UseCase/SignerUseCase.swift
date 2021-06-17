//
//  SignerUseCase.swift
//  Tweet
//
//  Created by addin on 16/06/21.
//

import Foundation
import Combine

protocol SignerUseCaseProtocol {
  func signUp(username: String, email: String, password: String) -> AnyPublisher<Bool, Error>
  func signIn(email: String, password: String) -> AnyPublisher<Bool, Error>
}

class SignerUseCase {
  
  private let repository: Repository
  init(repository: Repository) {
    self.repository = repository
  }
  
}

extension SignerUseCase: SignerUseCaseProtocol {
  
  func signUp(username: String, email: String, password: String) -> AnyPublisher<Bool, Error> {
    self.repository.signUp(username: username, email: email, password: password )
  }
  
  func signIn(email: String, password: String) -> AnyPublisher<Bool, Error> {
    self.repository.signIn(email: email, password: password)
  }
  
}
