//
//  UploadPresenter.swift
//  Tweet
//
//  Created by addin on 17/06/21.
//

import Foundation
import Combine

class UploadPresenter: ObservableObject {
  
  private var useCase: UploadUseCase
  
  @Published var isLoading = false
  @Published var isError = false
  @Published var errorMessage = ""
  
  private var cancellables: Set<AnyCancellable> = []
  
  init(useCase: UploadUseCase) {
    self.useCase = useCase
  }
  
  func upload(text: String, action: @escaping () -> Void) {
    self.isLoading = true
    self.isError = false
    self.errorMessage = ""
    useCase.uploadPost(text: text)
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
