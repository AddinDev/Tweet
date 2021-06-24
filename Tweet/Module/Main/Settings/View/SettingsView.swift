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
    HStack {
      VStack(alignment: .leading, spacing: 0) {
        Text(auth.user.username)
          .font(.system(size: 60))
          .fontWeight(.bold)
          .foregroundColor(.black)
        
        Text(auth.user.email)
          .font(.title)
          .fontWeight(.bold)
          .foregroundColor(.black)
        
        follows
        
        Spacer()
        
        logoutButton
        
        Spacer()
      }
      //        .padding(0)
      Spacer()
    }
  }
  
  var follows: some View {
    Group {
      Text("Following \(presenter.following.count)")
        .font(.headline)
        .padding(.top, 5)
      Text("Followers \(presenter.followers.count)")
        .font(.headline)
    }
    .foregroundColor(.black)
    .onTapGesture {
      showFollows = true
    }
  }
  
  var logoutButton: some View {
    HStack {
      Spacer()
      Button(action: {
        presenter.logout {
          auth.signOut()
        }
      }) {
        Text("logout")
          .font(.largeTitle)
          .fontWeight(.bold)
          .foregroundColor(.black)
      }
    }
  }
  
}
