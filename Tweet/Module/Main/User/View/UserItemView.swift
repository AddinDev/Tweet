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
      Text(user.username)
        .foregroundColor(Color("BW"))
        .padding()
      Spacer()
    }
    .background(Color("BW")
                  .opacity(0.05)
                  .cornerRadius(10))
    .padding(.horizontal)
    .padding(.top, 7)
  }
  
}
