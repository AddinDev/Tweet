//
//  HomeView.swift
//  Tweet
//
//  Created by addin on 11/06/21.
//

import SwiftUI
import SwiftUIX
import Combine

struct HomeView: View {
    
  @EnvironmentObject var auth: Authentication
  
  @ObservedObject var presenter: HomePresenter
  
  @State private var showUploadview = false
  
  var body: some View {
    GeometryReader { g in
      Group {
        ZStack() {
          if presenter.isLoading {
            loadingIndicator
          } else if posts.count == 0 {
            emptyIndicator
          } else if presenter.isError {
            errorIndicator
          } else {
            ScrollView(showsIndicators: false) {
              LazyVStack(spacing: 0) {
                ForEach(posts) { post in
                  presenter.linkToDetail(post: post) {
                    PostItemView(post: post, g: g)
                  }
                }
              }
            }
          }
          uploadButton
        }
      }
    }
    .animation(.spring())
    .onAppear {
      if posts.count == 0 {
        presenter.getPosts()
      }
    }
    .onReceive(Just(auth.hasSignedIn), perform: { value in
      if !value {
      if posts.count != 0 {
        presenter.followedPosts = []
        presenter.userPosts = []
      }
      }
    })
    .fullScreenCover(isPresented: $showUploadview, onDismiss: {
      // nun
    }) {
      presenter.makeUploadView()
    }
  }
}

extension HomeView {
  
  var posts: [PostModel] {
    presenter.sortPosts(presenter.followedPosts + presenter.userPosts)
  }
  
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
  
  var emptyIndicator: some View {
    Text("Empty")
  }
  
  //  var content: some View {
  //
  //  }
  
  var uploadButton: some View {
    HStack {
      Spacer()
      VStack {
        Spacer()
        Button(action: {
          showUploadview = true
        }) {
          Image(systemName: "square.and.arrow.up")
            .resizable()
            .scaledToFit()
            .foregroundColor(.white)
            .frame(width: 25)
            .padding()
            .background(BlurEffectView(style: .regular).clipShape(Circle()))
            .padding()
        }
      }
    }
    .padding(10)
  }
  
}
