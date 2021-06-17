//
//  TweetResponse.swift
//  Tweet
//
//  Created by addin on 16/06/21.
//

import Foundation

struct PostResponse: Identifiable {
  
  let id: String = UUID().uuidString
  let sender: String
  let text: String
  let date: String
  
}
