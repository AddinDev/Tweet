//
//  HomeView.swift
//  Tweet
//
//  Created by addin on 11/06/21.
//

import SwiftUI
import SwiftUIX

struct HomeView: View {
    
  @ObservedObject var presenter: HomePresenter
  
  @State private var showUploadview = false
  
  var body: some View {
    GeometryReader { g in
      Group {
        ZStack() {
          if presenter.isLoading {
            loadingIndicator
          } else if presenter.posts.count == 0 {
            emptyIndicator
          } else if presenter.isError {
            errorIndicator
          } else {
            ScrollView(showsIndicators: false) {
              LazyVStack(spacing: 0) {
                ForEach(presenter.posts) { post in
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
    .animation(.linear)
    .onAppear {
      presenter.getPosts()
    }
    .fullScreenCover(isPresented: $showUploadview, onDismiss: {
            presenter.getPosts()
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
  }
  
}
