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
  
  @State private var showFollows = false
  
  var body: some View {
    content
      .onAppear {
        if presenter.follows == [:] {
          presenter.checkFollows()
        }
      }
      .sheet(isPresented: $showFollows) {
        FollowListView(users: presenter.follows)
      }
  }
  
}

extension SettingsView {
  
  var loadingIndicator: some View {
    ProgressView()
      .progressViewStyle(CircularProgressViewStyle())
      .padding()
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
      follows
      logoutButton
    }
    .padding()
  }
  
  var follows: some View {
    Group {
      if presenter.isLoading {
        loadingIndicator
      } else if presenter.isError {
        errorIndicator
      } else {
        HStack {
          Text("Following \(presenter.follows["Following"]?.count ?? 0)")
          Spacer()
          Text("Followers \(presenter.follows["Followers"]?.count ?? 0)")
        }
        .foregroundColor(.primary)
        .padding()
        .onTapGesture {
          showFollows = true
        }
      }
    }
    .animation(.linear)
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
