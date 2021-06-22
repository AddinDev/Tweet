//
//  PostDetailRouter.swift
//  Tweet
//
//  Created by addin on 21/06/21.
//

import SwiftUI

class PostDetailRouter {
  
  func makeProfileView(user: UserModel) -> some View {
    let useCase = Injection.init().provideProfile()
    let presenter = ProfilePresenter(user: user, useCase: useCase)
    return ProfileView(presenter: presenter)
  }
  
}
