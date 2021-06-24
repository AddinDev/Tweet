//
//  FollowListView.swift
//  Tweet
//
//  Created by addin on 22/06/21.
//

import SwiftUI

struct FollowListView: View {
    
  @State var selected = 0
  
  let mode = ["Followers", "Following"]
  var followers: [UserModel]
  var following: [UserModel]

  var body: some View {
    content
  }
  
}

extension FollowListView {
  
  var content: some View {
    ZStack {
      Color("P")
        .edgesIgnoringSafeArea(.bottom)
    VStack {
      picker
      tab
      Spacer()
    }
    }
  }
  
  var picker: some View {
    HStack {
      Spacer()
      Picker("", selection: $selected) {
        ForEach(0 ..< mode.count) { i in
          Text(mode[i])
        }
      }
      .pickerStyle(SegmentedPickerStyle())
            .frame(width: 200, height: 10)
      Spacer()
    }
    .padding()
    .padding(.top, 10)
  }
  
  var tab: some View {
    TabView(selection: $selected) {
      FollowList(users: followers)
        .tag(0)
      FollowList(users: following)
        .tag(1)
    }
    .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
    .animation(.linear)
  }
}

struct FollowList: View {
  
  var users: [UserModel]
  
  var body: some View {
    ScrollView {
      LazyVStack(spacing: 0) {
        ForEach(users) { user in
          UserItemView(user: user)
        }
      }
    }
  }
  
}
