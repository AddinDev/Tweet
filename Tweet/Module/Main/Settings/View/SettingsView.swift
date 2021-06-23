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
        presenter.checkFollowing()
        presenter.checkFollowers()
      }
      .sheet(isPresented: $showFollows) {
        FollowListView(followers: presenter.followers,
                       following: presenter.following)
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
    HStack {
      Text("Following \(presenter.following.count)")
      Spacer()
      Text("Followers \(presenter.followers.count)")
    }
    .foregroundColor(.primary)
    .padding()
    .onTapGesture {
      showFollows = true
    }
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
