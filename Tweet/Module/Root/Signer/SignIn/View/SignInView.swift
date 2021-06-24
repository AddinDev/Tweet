//
//  SignInView.swift
//  Tweet
//
//  Created by addin on 17/06/21.
//

import SwiftUI

struct SignInView: View {
  
  @Environment(\.presentationMode) var presentationMode
  
  @EnvironmentObject var auth: Authentication
  @ObservedObject var presenter: SignInPresenter
  
  @State private var email = ""
  @State private var password = ""
  
  @State private var showSignUp = false
  
  var body: some View {
    ZStack {
      Color("P")
        .edgesIgnoringSafeArea(.bottom)
      Group {
        if presenter.isLoading {
          loadingIndicator
        } else {
          content
            .sheet(isPresented: $showSignUp) {
              presenter.makeSignUpView()
            }
        }
      }
      .animation(.linear)
    }
  }
}

extension SignInView {
  
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
        Text("Sign In")
          .foregroundColor(.primary)
          .padding(10)
          .background(Color(.systemGray6))
          .cornerRadius(8)
      }
      
      Spacer()
      
      HStack {
        Spacer()
        Button(action: {
          showSignUp = true
        }) {
          Text("don't have an account? make one.")
            .padding(5)
        }
      }
    }
  }
  
  private func authenticate() {
    presenter.signIn(email, password) {
      auth.signIn()
    }
    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
  }
  
}
