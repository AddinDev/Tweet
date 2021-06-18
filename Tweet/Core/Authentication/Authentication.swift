//
//  Authentication.swift
//  Tweet
//
//  Created by addin on 17/06/21.
//

import Foundation

struct Log: Codable {

  private var signedIn: Bool = false
  
  var hasSignedIn: Bool {
    set(newSignedIn) {
      self.signedIn = newSignedIn
    }
    get{
      return self.signedIn
    }
  }
}

struct AuthDataStore {
  
  static let shared = AuthDataStore()
  private let key = "tweet.savedUser"
  
  func save(_ user: Log) {
    let encoder = JSONEncoder()
    if let encoded = try? encoder.encode(user) {
      let defaults = UserDefaults.standard
      defaults.set(encoded, forKey: key)
    }
  }
  
  func load() -> Log {
    let defaults = UserDefaults.standard
    if let savedUser = defaults.object(forKey: key) as? Data {
      let decoder = JSONDecoder()
      if let loadedUser = try? decoder.decode(Log.self, from: savedUser) {
        return loadedUser
      }
    }
    return Log() // instantiate a new User and return
    // if it's not stored previously
  }
  
  func removeUser() {
    let defaults = UserDefaults.standard
    defaults.removeObject(forKey: key)
  }
  
}

class Authentication: User {
  
  @Published private var user = AuthDataStore.shared.load()
  
  var hasSignedIn: Bool {
    get {
      user.hasSignedIn
    }
    set(newHasSignedIn) {
      user.hasSignedIn = newHasSignedIn
    }
  }
  
}

extension Authentication {
  
  func signIn() {
    self.user.hasSignedIn = true
    AuthDataStore.shared.save(user)
    super.reload()
  }
  
  func signOut(){
    self.user.hasSignedIn = false
    AuthDataStore.shared.removeUser()
    super.remove()
  }
  
}
