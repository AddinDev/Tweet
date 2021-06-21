//
//  UserModel.swift
//  Tweet
//
//  Created by addin on 21/06/21.
//

import Foundation

struct UserModel: Identifiable {
  
  var id: String = UUID().uuidString
  var email: String = ""
  var username: String = ""
  var photoUrl: String?
  
}
