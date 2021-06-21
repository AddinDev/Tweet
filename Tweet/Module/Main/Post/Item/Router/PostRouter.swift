//
//  PostRouter.swift
//  Tweet
//
//  Created by addin on 21/06/21.
//

import SwiftUI

class PostItemRouter {
  
  func makeDetailView(post: PostModel) -> some View {
    return PostDetailView(post: post)
  }
  
}
