//
//  UserMapper.swift
//  Tweet
//
//  Created by addin on 22/06/21.
//

import Foundation

class UserMapper {
  
  static func responseToModel(_ responses: [UserResponse]) -> [UserModel] {
    return responses.map { response in
      return UserModel(id: UUID().uuidString, email: response.email, username: response.username, photoUrl: response.photoUrl)
    }
  }
  
}
