//
//  ContentView.swift
//  Tweet
//
//  Created by addin on 11/06/21.
//

import SwiftUI

struct ContentView: View {
  
  @EnvironmentObject var auth: Authentication
  @EnvironmentObject var signInPresenter: SignInPresenter
  
  var body: some View {
    content
  }
}

extension ContentView {
  
  var content: some View {
    Group {
      if auth.hasSignedIn {
        Button("logout mamank") {
          auth.signOut()
        }
      } else {
        SignInView(presenter: signInPresenter)
      }
    }
    .animation(.linear)
  }
  
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
