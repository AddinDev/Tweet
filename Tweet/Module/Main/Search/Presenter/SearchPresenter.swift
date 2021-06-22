//
//  SearchPresenter.swift
//  Tweet
//
//  Created by addin on 17/06/21.
//

import SwiftUI
import Combine

class SearchPresenter: ObservableObject {
    
  private var router = SearchRouter()
  private var useCase: SearchUseCase
  
  @Published var posts: [PostModel] = []
  @Published var users: [UserModel] = []
  
  @Published var isLoading = false
  @Published var isError = false
  
  @Published var errorMessage = ""
  @Published var searchText = String()
  
  private var cancellables: Set<AnyCancellable> = []
  
  
  init(useCase: SearchUseCase) {
    self.useCase = useCase
    
    $searchText
      .debounce(for: .milliseconds(300), scheduler: RunLoop.main)
      .removeDuplicates()
      .compactMap { $0 }
      .sink { _ in
      } receiveValue: { value in
        if !self.searchText.isEmpty {
          print(value)
          self.search()
        }
      }.store(in: &cancellables)
  }
  
  func getAllPosts() {
    self.isLoading = true
    self.isError = false
    self.errorMessage = ""
    useCase.getAllPosts()
      .sink { completion in
        switch completion {
        case .failure(let error):
          self.errorMessage = error.localizedDescription
          self.isError = true
          self.isLoading = false
        case .finished:
          self.isLoading = false
        }
      } receiveValue: { posts in
        self.posts = posts
      }
      .store(in: &cancellables)
  }
  
  func search() {
    self.isLoading = true
    self.isError = false
    self.errorMessage = ""
    useCase.searchUser(searchText.lowercased())
      .sink { completion in
        switch completion {
        case .failure(let error):
          self.errorMessage = error.localizedDescription
          self.isError = true
          self.isLoading = false
        case .finished:
          self.isLoading = false
        }
      } receiveValue: { users in
        self.users = users
      }
      .store(in: &cancellables)
  }
  
  func linkToDetail<Content: View>(post: PostModel, @ViewBuilder content: () -> Content) -> some View {
    NavigationLink(destination: router.makeDetailView(post: post)) { content() }
  }
  
  func linkToProfile<Content: View>(user: UserModel, @ViewBuilder content: () -> Content) -> some View {
    NavigationLink(destination: router.makeProfileView(user)) { content() }
  }
  
}
