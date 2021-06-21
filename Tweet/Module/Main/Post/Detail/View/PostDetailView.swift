//
//  PostDetailView.swift
//  Tweet
//
//  Created by addin on 21/06/21.
//

import SwiftUI

struct PostDetailView: View {
  
  var post: PostModel
  
  var body: some View {
    content
  }
  
}

extension PostDetailView {
  
  var content: some View {
    VStack {
      Text(post.text)
    }
  }
  
}
