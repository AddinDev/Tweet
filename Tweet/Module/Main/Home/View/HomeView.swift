//
//  HomeView.swift
//  Tweet
//
//  Created by addin on 11/06/21.
//

import SwiftUI

struct HomeView: View {
  
  private let numbers = [0, 1, 2, 3, 4, 5]
  
  var body: some View {
    NavigationView {
      content
        .navigationBarTitle("Tweet")
    }
  }
}

extension HomeView {
  
  var content: some View {
    ScrollView {
      VStack {
        Section(header: Text("HAHAHA")) {
          ForEach(0 ..< numbers.count) { i in
            Divider()
            Text("\(numbers[i])")
              .padding(0)
            if i == numbers.last {
              Divider()
            }
          }
        }
      }
    }
  }
  
}

struct HomeView_Previews: PreviewProvider {
  static var previews: some View {
    HomeView()
  }
}
