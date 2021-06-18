//
//  User.swift
//  Tweet
//
//  Created by addin on 18/06/21.
//

import Foundation
import Firebase

class User: ObservableObject {
      
  @Published var email: String = ""
  @Published var username: String = ""
  @Published var photoUrl: String?
  
  init() {
    load()
  }
  
  func remove() {
    print("user remove")
    self.email = ""
    self.username = ""
    self.photoUrl = nil
  }
    
  func reload() {
    load()
  }
  
  func load() {
    print("user load")
    if let userEmail = Auth.auth().currentUser?.email {
      Firestore.firestore().collection("Users")
        .document(userEmail)
        .getDocument { snapshot, error in
          if let error = error {
            print("error: \(error.localizedDescription)")
          } else {
            if let data = snapshot?.data() {
              if let email = data["email"] as? String, let username = data["username"] as? String, let photoUrl = data["photoUrl"] as? String? {
                self.email = email
                self.username = username
                self.photoUrl = photoUrl
                print("user: \(email) \(username) \(photoUrl ?? "potokosong")")
              }
            }
          }
        }
    } else {
      print("no user")
    }
  }
  
}
