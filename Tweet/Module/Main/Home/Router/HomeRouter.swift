//
//  HomeRouter.swift
//  Tweet
//
//  Created by addin on 17/06/21.
//

import SwiftUI

class HomeRouter {
  
  func makeUploadView() -> some View {
    let useCase = Injection.init().provideUpload()
    let presenter = UploadPresenter(useCase: useCase)
    return UploadView(presenter: presenter)
  }
  
  func makeDetailView(post: PostModel) -> some View {
    return PostDetailView(post: post)
  }
  
}
