//
//  SettingsPresenter.swift
//  Tweet
//
//  Created by addin on 18/06/21.
//

import Foundation
import Combine

class SettingsPresenter: ObservableObject {
  
  private var useCase: SettingsUseCase
  
  @Published var isLoading = false
  @Published var isError = false
  @Published var errorMessage = ""
  
  private var cancellables: Set<AnyCancellable> = []
  
  
  init(useCase: SettingsUseCase) {
    self.useCase = useCase
  }
  
  func logout(action: @escaping () -> Void) {
    self.isLoading = true
    self.errorMessage = ""
    self.isError = false
    useCase.signOut()
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
