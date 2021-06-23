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
  var users: [String: [UserModel]]
  
  var body: some View {
    content
      .onAppear {
        print(users)
      }
  }
  
}

extension FollowListView {
  
  var content: some View {
    VStack {
      picker
      tab
      Spacer()
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
      FollowList(users: users["Followers"]!)
        .tag(0)
      FollowList(users: users["Following"]!)
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
      LazyVStack {
        ForEach(users) { user in
          UserItemView(user: user)
        }
      }
    }
  }
  
}
