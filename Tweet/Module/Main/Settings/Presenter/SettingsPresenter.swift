//
//  SettingsPresenter.swift
//  Tweet
//
//  Created by addin on 18/06/21.
//

import SwiftUI
import Combine

class SettingsPresenter: ObservableObject {
  
  private var router = SettingsRouter()
  private var useCase: SettingsUseCase
  
  @Published var follows: [String: [UserModel]] = [:]
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
  
  func checkFollows() {
    self.isLoading = true
    self.errorMessage = ""
    self.isError = false
    useCase.checkFollows()
      .sink { completion in
        switch completion {
        case .failure(let error):
          self.errorMessage = error.localizedDescription
          self.isError = true
          self.isLoading = false
        case .finished:
          self.isLoading = false
        }
      } receiveValue: { follows in
        self.follows = follows
      }
      .store(in: &cancellables)
  }
  
  func makeListView() -> some View {
    self.router.makeListView(follows)
  }
  
  func linkToProfile<Content: View>(user: UserModel, @ViewBuilder content: () -> Content) -> some View {
    NavigationLink(destination: router.makeProfileView(user)) { content() }
  }
  
}
