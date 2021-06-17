//
//  SignUpPresenter.swift
//  Tweet
//
//  Created by addin on 16/06/21.
//

import SwiftUI
import Combine

class SignUpPresenter: ObservableObject {
  
  private var useCase: SignerUseCaseProtocol
  
  @Published var isLoading = false
  @Published var isError = false
  @Published var errorMessage = ""
  
  private var cancellables: Set<AnyCancellable> = []
  
  init(useCase: SignerUseCaseProtocol) {
    self.useCase = useCase
  }
  
  func signUp(_ username: String, _ email: String, _ password: String, action:  @escaping () -> Void) {
    self.isLoading = true
    self.isError = false
    self.errorMessage = ""
    self.useCase.signUp(username: username, email: email, password: password)
      .sink { completion in
        switch completion {
        case .failure(let error):
          self.errorMessage = error.localizedDescription
          self.isError = true
          self.isLoading = false
        case .finished:
          self.isLoading = false
          action()
        }
      } receiveValue: { _ in
      }
      .store(in: &cancellables)
  }
  
}
