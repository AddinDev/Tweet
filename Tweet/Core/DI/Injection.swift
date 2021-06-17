//
//  Injection.swift
//  Tweet
//
//  Created by addin on 16/06/21.
//

import Foundation
import Combine

final class Injection {
  
  private func provideRepo() -> Repository {
    let remote = RemoteDataSource.sharedInstance
    return Repository(remote: remote)
  }
  
  func provideSigner() -> SignerUseCase {
    return SignerUseCase(repository: provideRepo())
  }
  
}
