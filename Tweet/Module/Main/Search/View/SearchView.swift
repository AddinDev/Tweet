//
//  SearchView.swift
//  Tweet
//
//  Created by addin on 17/06/21.
//

import SwiftUI

struct SearchView: View {
  
  @ObservedObject var presenter: SearchPresenter
    
  
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
    .onAppear {
//      if presenter.posts.count == 0 {
        presenter.getAllPosts()
//      }
    }
  }
}

extension SearchView {
  
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
    ScrollView {
      VStack {
        ForEach(presenter.posts) { post in
          PostItemView(post: post, last: post == presenter.posts.last ? true : false)
        }
      }
    }
  }
  
}


