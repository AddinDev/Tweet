//
//  HomeView.swift
//  Tweet
//
//  Created by addin on 11/06/21.
//

import SwiftUI

struct HomeView: View {
  
  @ObservedObject var presenter: HomePresenter
  
  @State private var showUploadview = false
  
  var body: some View {
    Group {
      ZStack() {
        if presenter.isLoading {
          loadingIndicator
        } else if presenter.posts.count == 0 {
          emptyIndicator
        } else if presenter.isError {
          errorIndicator
        } else {
          content
        }
        uploadButton
      }
    }
    .animation(.linear)
    .onAppear {
      if presenter.posts.count == 0 {
        presenter.getPosts()
      }
    }
    .fullScreenCover(isPresented: $showUploadview, onDismiss: {
      //      presenter.getAllPosts()
    }) {
      presenter.makeUploadView()
    }
  }
}

extension HomeView {
  
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
  
  var content: some View {
    ScrollView {
      VStack {
        ForEach(presenter.posts) { post in
          PostItemView(post: post, last: post == presenter.posts.last ? true : false)
        }
      }
    }
  }
  
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
            .background(Circle().foregroundColor(.blue))
            .padding()
        }
      }
    }
  }
  
}
