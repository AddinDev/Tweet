//
//  SearchRouter.swift
//  Tweet
//
//  Created by addin on 21/06/21.
//

import SwiftUI

class SearchRouter {
  
  func makeDetailView(post: PostModel) -> some View {
    return PostDetailView(post: post)
  }
  
  func makeProfileView(_ user: UserModel) -> some View {
    let useCase = Injection.init().provideProfile()
    let presenter = ProfilePresenter(user: user, useCase: useCase)
    return ProfileView(presenter: presenter)
  }
  
}
