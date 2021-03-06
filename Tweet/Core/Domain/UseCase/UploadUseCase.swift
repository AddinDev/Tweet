//
//  UploadUseCase.swift
//  Tweet
//
//  Created by addin on 17/06/21.
//

import Foundation
import Combine

protocol UploadUseCaseProtocol {
  func uploadPost(user: UserModel, text: String) -> AnyPublisher<Bool, Error>
}

class UploadUseCase {
  
  private let repository: Repository
  init(repository: Repository) {
    self.repository = repository
  }
  
}

extension UploadUseCase: UploadUseCaseProtocol {
  
  func uploadPost(user: UserModel, text: String) -> AnyPublisher<Bool, Error> {
    self.repository.uploadPost(user: user, text: text)
  }
  
}
