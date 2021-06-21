//
//  PostItemView.swift
//  Tweet
//
//  Created by addin on 17/06/21.
//

import SwiftUI

struct PostItemView: View {
  
  
  var post: PostModel
  var last: Bool
  
  var body: some View {
      content
        .foregroundColor(.primary)
  }
  
}

extension PostItemView {
  
  var content: some View {
    VStack(alignment: .leading) {
      Divider()
      VStack(alignment: .leading) {
        HStack {
          Text(post.user.username)
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
  
}
