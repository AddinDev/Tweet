//
//  PostModel.swift
//  Tweet
//
//  Created by addin on 16/06/21.
//

import Foundation

struct PostModel: Identifiable, Equatable {
  
  static func == (lhs: PostModel, rhs: PostModel) -> Bool {
    return true
  }
  
  let id: String
  let text: String
  let date: String
  let user: UserModel
  
}
