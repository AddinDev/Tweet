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
  
  func provideUpload() -> UploadUseCase {
    return UploadUseCase(repository: provideRepo())
  }
  
  func provideSettings() -> SettingsUseCase {
    return SettingsUseCase(repository: provideRepo())
  }
  
  func provideHome() -> HomeUseCase {
    return HomeUseCase(repository: provideRepo())
  }
  
  func provideSearch() -> SearchUseCase {
    return SearchUseCase(repository: provideRepo())
  }
  
  func provideProfile() -> ProfileUseCase {
    return ProfileUseCase(repository: provideRepo())
  }
  
}
