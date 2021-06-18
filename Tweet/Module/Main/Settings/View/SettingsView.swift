//
//  SettingsView.swift
//  Tweet
//
//  Created by addin on 17/06/21.
//

import SwiftUI

struct SettingsView: View {
  
  @EnvironmentObject var auth: Authentication
  
  @ObservedObject var presenter: SettingsPresenter
  
  var body: some View {
    Group {
      if presenter.isLoading {
        loadingIndicator
      } else if presenter.isError {
        errorIndicator
      } else {
        content
      }
    }
    .animation(.linear)
  }
  
}

extension SettingsView {
  
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
      Text(auth.email)
      Text(auth.username)
      logoutButton
    }
    .padding()
  }
  
  var logoutButton: some View {
    Button(action: {
      presenter.logout {
        auth.signOut()
      }
    }) {
      Text("Logout")
    }
  }
  
}
