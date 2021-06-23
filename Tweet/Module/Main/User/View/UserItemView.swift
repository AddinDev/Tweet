//
//  UserItemView.swift
//  Tweet
//
//  Created by addin on 22/06/21.
//

import SwiftUI

struct UserItemView: View {
  
  var user: UserModel
  
  var body: some View {
    HStack {
      HStack(alignment: .firstTextBaseline) {
        VStack(alignment: .leading) {
          Text(user.username)
            .font(.largeTitle)
            .fontWeight(.bold)
            .foregroundColor(.black)
            .lineLimit(4)
          //          nospaceTags(tags: post.postType)
          Spacer()
          Divider().frame(height: 0.5).background(Color.black)
          .padding(.bottom, 20)
        }
        .padding(.top, 30)
      }
      .padding(.horizontal)
    }
    .background(Color.lighterPink)
  }
  
}
