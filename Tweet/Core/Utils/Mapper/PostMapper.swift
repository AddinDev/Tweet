//
//  PostMapper.swift
//  Tweet
//
//  Created by addin on 16/06/21.
//

import Foundation

class PostMapper {
  
  static func postsResponseToModel(for responses: [PostResponse]) -> [PostModel] {
    return responses.map { response in
      return PostModel(id: response.id, text: response.text,
                       date: response.date, user: UserModel(id: response.email, email: response.email, username: response.sender, photoUrl: nil))
    }
  }
  
}
