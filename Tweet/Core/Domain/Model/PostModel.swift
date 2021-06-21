//
//  PostModel.swift
//  Tweet
//
//  Created by addin on 16/06/21.
//

import Foundation

struct PostModel: Identifiable, Equatable {
  
  let id: String
  let sender: String
  let email: String
  let text: String
  let date: String
  
}
