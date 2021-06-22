//
//  ProfileView.swift
//  Tweet
//
//  Created by addin on 21/06/21.
//

import SwiftUI

struct ProfileView: View {
  
  @EnvironmentObject var auth: Authentication
  @ObservedObject var presenter: ProfilePresenter
  
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
    .navigationBarTitle(presenter.user.username)
    .navigationBarItems(trailing: followButton)
    .onAppear {
      presenter.checkFollowStatus(auth.user)
      presenter.getPosts()
    }
  }
  
}

extension ProfileView {
  
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
    list
  }
  
  var list: some View {
    ScrollView {
      VStack {
        ForEach(presenter.posts) { post in
          PostItemView(post: post, last: post == presenter.posts.last ? true : false)
        }
      }
    }
  }
  
  var followButton: some View {
    Group {
      if auth.user.email == presenter.user.email {
        
      } else {
        if presenter.followLoading {
          ProgressView()
            .progressViewStyle(CircularProgressViewStyle())
        } else if presenter.isFollowing {
          Text("Followed")
        } else {
          Button(action: {
            presenter.follow(auth.user)
          }) {
            Text("Follow")
          }
        }
      }
    }
  }
  
}
