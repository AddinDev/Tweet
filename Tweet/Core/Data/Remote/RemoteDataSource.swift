//
//  RemoteDataSource.swift
//  Tweet
//
//  Created by addin on 16/06/21.
//

import Foundation
import Combine
import Firebase

protocol RemoteDataSourceProtocol {
  func signUp(username: String, email: String, password: String) -> AnyPublisher<Bool, Error>
  func signIn(email: String, password: String) -> AnyPublisher<Bool, Error>
  func signOut() -> AnyPublisher<Bool, Error>
  func getAllPosts() -> AnyPublisher<[PostResponse], Error>
  func uploadPost(text: String) -> AnyPublisher<Bool, Error>
}

final class RemoteDataSource {
    
  private let db = Firestore.firestore()
  private let auth = Auth.auth()
  private let users = "Users"
  private let posts = "Posts"
  
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
                   let date = data["date"] as? String {
                  let post = PostResponse(sender: sender, text: text, date: date)
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
  
  func uploadPost(text: String) -> AnyPublisher<Bool, Error> {
    return Future<Bool, Error> { completion in
      if let userEmail = self.auth.currentUser?.email {
        self.db.collection(self.users)
          .document(userEmail)
          .getDocument { snapshot, error in
            if let error = error {
              completion(.failure(error))
              print("error: \(error)")
            } else {
              if let data = snapshot?.data() {
                if let username = data["username"] as? String {
                  self.db.collection(self.posts)
                    .addDocument(data: [
                      "text": text,
                      "sender": username,
                      "email": userEmail,
                      "date": Date().getFormattedDate(format: "dd/MM/yy")
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
          }
      }
      
    }
    .eraseToAnyPublisher()
  }
  
}
