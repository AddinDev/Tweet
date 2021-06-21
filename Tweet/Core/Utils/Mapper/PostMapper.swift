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
      return PostModel(id: response.id, sender: response.sender, email: response.email,
                       text: response.text, date: response.date)
    }
  }
  
}
