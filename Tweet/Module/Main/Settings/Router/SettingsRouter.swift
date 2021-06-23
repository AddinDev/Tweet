//
//  SettingsRouter.swift
//  Tweet
//
//  Created by addin on 22/06/21.
//

import SwiftUI

class SettingsRouter {
  
  func makeListView(_ followers: [UserModel], _ following: [UserModel]) -> some View {
    return FollowListView(followers: followers, following: following)
  }
  
  func makeProfileView(_ user: UserModel) -> some View {
    let useCase = Injection.init().provideProfile()
    let presenter = ProfilePresenter(user: user, useCase: useCase)
    return ProfileView(presenter: presenter)
  }
  
}
