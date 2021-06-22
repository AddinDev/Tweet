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
    VStack {
      VStack(alignment: .leading) {
        Divider()
        HStack {
          Text(user.username)
          Spacer()
        }
        .padding(.horizontal, 10)
        Divider()
      }
    }
  }
  
}
