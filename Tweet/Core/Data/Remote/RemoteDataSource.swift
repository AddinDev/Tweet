//
//  RemoteDataSource.swift
//  Tweet
//
//  Created by addin on 16/06/21.
//

import SwiftUI
import Combine
import Firebase

protocol RemoteDataSourceProtocol {
  func signUp(username: String, email: String, password: String) -> AnyPublisher<Bool, Error>
  func signIn(email: String, password: String) -> AnyPublisher<Bool, Error>
  func signOut() -> AnyPublisher<Bool, Error>
  
  func uploadPost(user: UserModel, text: String) -> AnyPublisher<Bool, Error>
  func getAllPosts() -> AnyPublisher<[PostResponse], Error>
  func getUserPosts(of email: String) -> AnyPublisher<[PostResponse], Error>
  func getFollowedPosts() -> AnyPublisher<[PostResponse], Error>
  
  func follow(this currentUser: UserModel, for user: UserModel) -> AnyPublisher<Bool, Error>
  func checkFollowStatus(this currentUser: UserModel, for user: UserModel) -> AnyPublisher<Bool, Error>
  
  func searchUser(_ username: String) -> AnyPublisher<[UserResponse], Error>

  // idk how to map these, so i did these as model
  func checkFollowers() -> AnyPublisher<[UserModel], Error>
  func checkFollowing() -> AnyPublisher<[UserModel], Error>
}

final class RemoteDataSource {
  
  private let db = Firestore.firestore()
  private let auth = Auth.auth()
  private let users = "Users"
  private let posts = "Posts"
  private let following = "Following"
  private let followers = "Followers"
  
  init() {
    //              >///<
  }
  
  static let sharedInstance = RemoteDataSource()
  
}

extension RemoteDataSource: RemoteDataSourceProtocol {
  
  func signUp(username: String, email: String, password: String) -> AnyPublisher<Bool, Error> {
    return Future<Bool, Error> { completion in
      Auth.auth().createUser(withEmail: email, password: password) { result, error in
        if let error = error {
          completion(.failure(error))
          print("error: \(error)")
        } else {
          self.db.collection(self.users)
            .document(email)
            .setData([
              "username": username,
              "email": email
            ]) { error in
              if let error = error {
                completion(.failure(error))
              } else {
                completion(.success(true))
              }
            }
        }
      }
    }
    .eraseToAnyPublisher()
  }
  
  func signIn(email: String, password: String) -> AnyPublisher<Bool, Error> {
    return Future<Bool, Error> { completion in
      Auth.auth().signIn(withEmail: email, password: password) { result, error in
        if let error = error {
          completion(.failure(error))
          print("error: \(error)")
        } else {
          completion(.success(true))
        }
      }
    }
    .eraseToAnyPublisher()
  }
  
  func signOut() -> AnyPublisher<Bool, Error> {
    return Future<Bool, Error> { completion in
      do {
        try self.auth.signOut()
        completion(.success(true))
      } catch let error {
        completion(.failure(error))
        print("error: \(error)")
      }
    }
    .eraseToAnyPublisher()
  }
  
  func getAllPosts() -> AnyPublisher<[PostResponse], Error> {
    return Future<[PostResponse], Error> { completion in
      self.db.collection(self.posts)
        .getDocuments { snapshot, error in
          if let error = error {
            completion(.failure(error))
            print("error: \(error)")
          } else {
            if let snapshot = snapshot {
              var posts: [PostResponse] = []
              for doc in snapshot.documents {
                let data = doc.data()
                if let text = data["text"] as? String,
                   let sender = data["sender"] as? String,
                   let email = data["email"] as? String,
                   let date = data["date"] as? String {
                  let post = PostResponse(sender: sender, email: email, text: text, date: date)
                  posts.append(post)
                }
              }
              completion(.success(posts))
            }
          }
        }
    }
    .eraseToAnyPublisher()
  }
  
  func uploadPost(user: UserModel, text: String) -> AnyPublisher<Bool, Error> {
    return Future<Bool, Error> { completion in
      self.db.collection(self.posts)
        .addDocument(data: [
          "text": text,
          "sender": user.username,
          "email": user.email,
          "date": Date().getFormattedDate(format: "dd/MM/yy HH:mm")
        ]) { error in
          if let error = error {
            completion(.failure(error))
            print("error: \(error)")
          } else {
            completion(.success(true))
          }
        }
    }
    .eraseToAnyPublisher()
  }
  
  func getUserPosts(of email: String) -> AnyPublisher<[PostResponse], Error> {
    return Future<[PostResponse], Error> { completion in
      self.db.collection(self.posts)
        .whereField("email", isEqualTo: email)
        .getDocuments { snapshot, error in
          if let error = error {
            completion(.failure(error))
            print("error: \(error)")
          } else {
            if let snapshot = snapshot {
              var posts: [PostResponse] = []
              for doc in snapshot.documents {
                let data = doc.data()
                if let text = data["text"] as? String,
                   let sender = data["sender"] as? String,
                   let email = data["email"] as? String,
                   let date = data["date"] as? String {
                  let post = PostResponse(sender: sender, email: email, text: text, date: date)
                  posts.append(post)
                }
              }
              print("posts: \(posts)")
              completion(.success(posts))
            }
          }
        }
    }
    .eraseToAnyPublisher()
  }
  
  func getFollowedPosts() -> AnyPublisher<[PostResponse], Error> {
    return Future<[PostResponse], Error> { completion in
      if let userEmail = self.auth.currentUser?.email {
        self.db.collection(self.users)
          .document(userEmail)
          .collection(self.following)
          .getDocuments { snapshots, error in
            if let error = error {
              completion(.failure(error))
              print("error: \(error)")
            } else {
              if let snapshots = snapshots?.documents {
                var posts: [PostResponse] = []

                // get user itself
                self.db.collection(self.posts)
                  .whereField("email", isEqualTo: userEmail)
                  .getDocuments { snapshots, error in
                    if let error = error {
                      completion(.failure(error))
                      print("error: \(error)")
                    } else {
                      if let snapshots = snapshots?.documents {
                        for snapshot in snapshots {
                          let data = snapshot.data()
                          if let text = data["text"] as? String,
                             let sender = data["sender"] as? String,
                             let email = data["email"] as? String,
                             let date = data["date"] as? String {
                            let post = PostResponse(sender: sender, email: email, text: text, date: date)
                            posts.append(post)
                          }
                        }
                      }
                    }
                  }

                // get followed
                for snapshot in snapshots {
                  let data = snapshot.data()
                  if let email = data["email"] as? String {
                    self.db.collection(self.posts)
                      .whereField("email", isEqualTo: email)
                      .getDocuments { snapshots, error in
                        if let error = error {
                          completion(.failure(error))
                          print("error: \(error)")
                        } else {
                          if let snapshots = snapshots?.documents {
                            for snapshot in snapshots {
                              let data = snapshot.data()
                              if let text = data["text"] as? String,
                                 let sender = data["sender"] as? String,
                                 let email = data["email"] as? String,
                                 let date = data["date"] as? String {
                                let post = PostResponse(sender: sender, email: email, text: text, date: date)
                                posts.append(post)
                              }
                            }
                          }
                        }
                      }
                  }
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                  completion(.success(posts))
                }
              }
            }
          }
      }
    }
    .eraseToAnyPublisher()
  }
  
  func checkFollowers() -> AnyPublisher<[UserModel], Error> {
    return Future<[UserModel], Error> { completion in
      if let userEmail = self.auth.currentUser?.email {
        self.db.collection(self.users)
          .document(userEmail)
          .collection(self.followers)
          .getDocuments { snapshots, error in
            if let error = error {
              completion(.failure(error))
              print("error: \(error)")
            } else {
              if let snapshots = snapshots?.documents {
                var follows: [UserModel] = []
                for snapshot in snapshots {
                  let data = snapshot.data()
                  if let email = data["email"] as? String,
                     let username = data["username"] as? String,
                     let photoUrl = data["photoUrl"] as? String? {
                    let user = UserModel(id: UUID().uuidString, email: email, username: username, photoUrl: photoUrl)
                    follows.append(user)
                  }
                }
                completion(.success(follows))
              }
            }
          }
      }
    }
    .eraseToAnyPublisher()
  }
  
  func checkFollowing() -> AnyPublisher<[UserModel], Error> {
    return Future<[UserModel], Error> { completion in
      if let userEmail = self.auth.currentUser?.email {
        self.db.collection(self.users)
          .document(userEmail)
          .collection(self.following)
          .getDocuments { snapshots, error in
            if let error = error {
              completion(.failure(error))
              print("error: \(error)")
            } else {
              if let snapshots = snapshots?.documents {
                var follows: [UserModel] = []
                for snapshot in snapshots {
                  let data = snapshot.data()
                  if let email = data["email"] as? String,
                     let username = data["username"] as? String,
                     let photoUrl = data["photoUrl"] as? String? {
                    let user = UserModel(email: email, username: username, photoUrl: photoUrl)
                    follows.append(user)
                  }
                }
                completion(.success(follows))
              }
            }
          }
      }
    }
    .eraseToAnyPublisher()
  }
  
  func searchUser(_ username: String) -> AnyPublisher<[UserResponse], Error> {
    return Future<[UserResponse], Error> { completion in
      self.db.collection(self.users)
        .whereField("username", isEqualTo: username)
        .getDocuments { snapshots, error in
          if let error = error {
            completion(.failure(error))
            print("error: \(error)")
          } else {
            if let snapshots = snapshots?.documents {
              var users: [UserResponse] = []
              for snapshot in snapshots {
                let data = snapshot.data()
                if let email = data["email"] as? String,
                   let username = data["username"] as? String,
                   let photoUrl = data["photoUrl"] as? String? {
                  let user = UserResponse(email: email, username: username, photoUrl: photoUrl)
                  users.append(user)
                }
              }
              completion(.success(users))
            }
          }
        }
    }
    .eraseToAnyPublisher()
  }
  
  func follow(this currentUser: UserModel, for user: UserModel) -> AnyPublisher<Bool, Error> {
    return Future<Bool, Error> { completion in
      self.db.collection(self.users)
        .document(currentUser.email)
        .collection(self.following)
        .document(user.email)
        .setData([
          "email": user.email,
          "username": user.username
        ]) { error in
          if let error = error {
            completion(.failure(error))
            print("error: \(error)")
          } else {
            self.db.collection(self.users)
              .document(user.email)
              .collection(self.followers)
              .document(currentUser.email)
              .setData([
                "email": currentUser.email,
                "username": currentUser.username
              ]) { error in
                if let error = error {
                  completion(.failure(error))
                  print("error: \(error)")
                } else {
                  completion(.success(true))
                }
              }
          }
        }
    }
    .eraseToAnyPublisher()
  }
  
  func checkFollowStatus(this currentUser: UserModel, for user: UserModel) -> AnyPublisher<Bool, Error> {
    return Future<Bool, Error> { completion in
      self.db.collection(self.users)
        .document(currentUser.email)
        .collection(self.following)
        .whereField("email", isEqualTo: user.email)
        .getDocuments { snapshot, error in
          if let error = error {
            completion(.failure(error))
            print("error: \(error)")
          } else {
            if let snapshots = snapshot?.documents {
              if snapshots.count == 0 {
                completion(.success(false))
                print("snap: 0")
              } else {
                completion(.success(true))
                print("snap: ada")
              }
            } else {
              completion(.success(false))
              print("snap: nil")
            }
          }
        }
    }
    .eraseToAnyPublisher()
  }
  
}
