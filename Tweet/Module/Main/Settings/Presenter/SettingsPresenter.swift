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
  
  @Published var followers: [UserModel] = []
  @Published var following: [UserModel] = []
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
  
  func checkFollowers() {
    self.isLoading = true
    self.errorMessage = ""
    self.isError = false
    useCase.checkFollowers()
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
        self.followers = follows
      }
      .store(in: &cancellables)
  }
  
  func checkFollowing() {
    self.isLoading = true
    self.errorMessage = ""
    self.isError = false
    useCase.checkFollowing()
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
        self.following = follows
      }
      .store(in: &cancellables)
  }
  
  func makeListView() -> some View {
    self.router.makeListView(followers, following)
  }
  
  func linkToProfile<Content: View>(user: UserModel, @ViewBuilder content: () -> Content) -> some View {
    NavigationLink(destination: router.makeProfileView(user)) { content() }
  }
  
}
