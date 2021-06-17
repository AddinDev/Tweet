//
//  SignInRouter.swift
//  Tweet
//
//  Created by addin on 17/06/21.
//

import SwiftUI

class SignInRouter {
  
  func makeSignUp() -> some View {
    let useCase = Injection.init().provideSigner()
    let presenter = SignUpPresenter(useCase: useCase)
    return SignUpView(presenter: presenter)
  }
  
}
