//
//  UserResponse.swift
//  Tweet
//
//  Created by addin on 22/06/21.
//

import Foundation

struct UserResponse: Identifiable {
  
  var id: String = UUID().uuidString
  var email: String = ""
  var username: String = ""
  var photoUrl: String?
  
}
