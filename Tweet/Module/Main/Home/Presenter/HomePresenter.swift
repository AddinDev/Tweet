//
//  HomePresenter.swift
//  Tweet
//
//  Created by addin on 16/06/21.
//

import SwiftUI
import Combine

class HomePresenter: ObservableObject {
  
  private var router = HomeRouter()
  
  private var useCase: HomeUseCase
  
  @Published var posts: [PostModel] = []
  @Published var isLoading = false
  @Published var isError = false
  @Published var errorMessage = ""
  
  private var cancellables: Set<AnyCancellable> = []

  
  init(useCase: HomeUseCase) {
    self.useCase = useCase
    
    
    self.posts = [
      PostModel(id: UUID().uuidString, sender: "udin", text: "mk3 supra is cool", date: "11 april"),
      PostModel(id: UUID().uuidString, sender: "udin", text: "mk3 supra is cool", date: "11 april"),
      PostModel(id: UUID().uuidString, sender: "udin", text: "mk3 supra is cool", date: "11 april"),
      PostModel(id: UUID().uuidString, sender: "udin", text: "mk3 supra is cool", date: "11 april")
    ]
  }
  
  func makeUploadView() -> some View {
    self.router.makeUploadView()
  }
  
//  func getAllPosts() {
//    self.isLoading = true
//    self.isError = false
//    self.errorMessage = ""
//    useCase.getAllPosts()
//      .sink { completion in
//        switch completion {
//        case .failure(let error):
//          self.errorMessage = error.localizedDescription
//          self.isError = true
//          self.isLoading = false
//        case .finished:
//          self.isLoading = false
//        }
//      } receiveValue: { posts in
//        self.posts = posts
//      }
//      .store(in: &cancellables)
//  }
  
}
