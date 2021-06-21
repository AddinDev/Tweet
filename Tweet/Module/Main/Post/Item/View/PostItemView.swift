//
//  PostItemView.swift
//  Tweet
//
//  Created by addin on 17/06/21.
//

import SwiftUI

struct PostItemView: View {
  
  var router = PostItemRouter()
  
  var post: PostModel
  var last: Bool
  
  var body: some View {
    linkBuilder(post: post) {
      content
        .foregroundColor(.primary)
    }
  }
  
}

extension PostItemView {
  
  var content: some View {
    VStack(alignment: .leading) {
      Divider()
      VStack(alignment: .leading) {
        HStack {
          Text(post.sender)
            .font(.headline)
          Spacer()
          Text(post.date)
            .fontWeight(.light)
        }
        Text(post.text)
          .font(.none)
      }
      .padding(.horizontal, 10)
      if last {
        Divider()
      }
    }
  }
  
  func linkBuilder<Content: View>(post: PostModel, @ViewBuilder content: () -> Content) -> some View {
    NavigationLink(destination: router.makeDetailView(post: post)) { content() }
  }
  
}
