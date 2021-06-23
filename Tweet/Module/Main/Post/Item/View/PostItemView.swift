//
//  PostItemView.swift
//  Tweet
//
//  Created by addin on 17/06/21.
//

import SwiftUI

struct PostItemView: View {

  var post: PostModel
  var g: GeometryProxy
  
  var body: some View {
      content
        .foregroundColor(.primary)
  }

}

extension PostItemView {

  var content: some View {
    HStack {
      HStack(alignment: .firstTextBaseline) {
        VStack(alignment: .leading) {
          Text(post.text)
            .font(.largeTitle)
            .fontWeight(.bold)
            .foregroundColor(.black)
            .lineLimit(4)
          //          nospaceTags(tags: post.postType)
          Spacer()
          Divider().frame(height: 0.5).background(Color.black)
          HStack {
            Text(post.user.username)
              .font(.caption)
              .foregroundColor(.black)
            Spacer()
            Text(post.date)
              .font(.caption)
              .foregroundColor(.black)
          }
          .padding(.bottom, 20)
        }
        .padding(.top, 30)
      }
      .padding(.horizontal)
    }
    .background(Color.lighterPink)
//    .frame(width: g.size.width, height: g.size.height / 2.5)
  }

}


