//
//  SettingsView.swift
//  Tweet
//
//  Created by addin on 17/06/21.
//

import SwiftUI

struct SettingsView: View {
  
  @EnvironmentObject var auth: Authentication
  
  var body: some View {
    Button("logout") {
      auth.signOut()
    }
  }
  
}
