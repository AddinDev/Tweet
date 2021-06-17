//
//  SignUpView.swift
//  Tweet
//
//  Created by addin on 16/06/21.
//

import SwiftUI

struct SignUpView: View {
  
  @EnvironmentObject var auth: Authentication
  @ObservedObject var presenter: SignUpPresenter
  
  @State private var username = ""
  @State private var email = ""
  @State private var password = ""
  
  var body: some View {
    Group {
      if presenter.isLoading {
        loadingIndicator
      } else {
        content
      }
    }
    .animation(.linear)
  }
}

extension SignUpView {
  
  var loadingIndicator: some View {
    VStack {
      Text("Loading...")
      ProgressView()
        .progressViewStyle(CircularProgressViewStyle())
    }
  }
  
  var errorIndicator: some View {
    Text(presenter.errorMessage)
      .foregroundColor(.red)
      .padding()
  }
  
  var content: some View {
    
    VStack {
      Spacer()
      if presenter.isError {
        errorIndicator
      }
      Group {
        TextField("username", text: $username)
        TextField("email", text: $email)
        SecureField("password", text: $password)
      }
      .disableAutocorrection(true)
      .autocapitalization(.none)
      .padding(10)
      .background(Color(.systemGray6))
      .cornerRadius(8)
      .padding(8)
      
      Button(action: {
        authenticate()
      }) {
        Text("Sign Up")
          .padding(10)
          .background(Color(.systemGray6))
          .cornerRadius(8)
      }
      
      Spacer()
    }
  }
  
  private func authenticate() {
    presenter.signUp(username, email, password) {
      auth.signIn()
    }
    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
  }
  
}
