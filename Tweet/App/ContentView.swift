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
  @EnvironmentObject var settingsPresenter: SettingsPresenter
  @EnvironmentObject var homePresenter: HomePresenter
  @EnvironmentObject var searchPresenter: SearchPresenter
  
  @State private var selected = 1
  
  var body: some View {
    content
  }
}

extension ContentView {
  
  var content: some View {
    Group {
      if auth.hasSignedIn {
        main
      } else {
        signer
      }
    }
    .animation(.linear)
  }
  
  var main: some View {
    TabView(selection: $selected) {
      SettingsView(presenter: settingsPresenter)
        .tabItem {
          Image(systemName: "gear")
        }
        .tag(0)
      HomeView(presenter: homePresenter)
        .tabItem {
          Image(systemName: "house")
        }
        .tag(1)
      SearchView(presenter: searchPresenter)
        .tabItem {
          Image(systemName: "magnifyingglass")
        }
        .tag(2)
    }
    .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
    .accentColor(.blue)
  }
  
  var signer: some View {
    SignInView(presenter: signInPresenter)
  }
  
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
