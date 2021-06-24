//
//  PostDetailView.swift
//  Tweet
//
//  Created by addin on 21/06/21.
//

import SwiftUI

struct PostDetailView: View {
  
  var router = PostDetailRouter()
  
  var post: PostModel
  
  var body: some View {
    ZStack {
      Color("P")
        .edgesIgnoringSafeArea(.bottom)
      content
    }
    .navigationBarTitleDisplayMode(.inline)
    //      .navigationBarTitle(post.user.username)
    .navigationBarItems(trailing: Text(post.date)
                          .fontWeight(.light))
  }
  
}

extension PostDetailView {
  
  var content: some View {
    VStack {
      Spacer()
      Text(post.text)
        .font(.title2)
      NavigationLink(destination: router.makeProfileView(user: post.user)) {
        Text(post.user.username)
//          .bold()
      }
      Spacer()
    }
    .padding()
  }
  
}
