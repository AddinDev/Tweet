//
//  HomePresenter.swift
//  Tweet
//
//  Created by addin on 16/06/21.
//

import SwiftUI
import Firebase
import Combine

class HomePresenter: ObservableObject {
  
  private var router = HomeRouter()
  
  private var useCase: HomeUseCase
  
  @Published var followedPosts: [PostModel] = []
  @Published var userPosts: [PostModel] = []
  
  @Published var isLoading = false
  @Published var isError = false
  @Published var errorMessage = ""
  
  private var cancellables: Set<AnyCancellable> = []
  
  
  init(useCase: HomeUseCase) {
    self.useCase = useCase
  }
  
  func makeUploadView() -> some View {
    self.router.makeUploadView()
  }
  
  func getPosts() {
    self.getFollowedPosts()
    self.getUserPosts()
  }
  
  //  func getPosts() {
  //    self.isLoading = true
  //    self.isError = false
  //    self.errorMessage = ""
  //    useCase.getFollowedPosts()
  //      .sink { completion in
  //        switch completion {
  //        case .failure(let error):
  //          self.errorMessage = error.localizedDescription
  //          self.isError = true
  //          self.isLoading = false
  //        case .finished:
  //          self.isLoading = false
  //        }
  //      } receiveValue: { posts in
  //        self.posts = self.sortPosts(posts)
  //        print("posts: \(posts)")
  //      }
  //      .store(in: &cancellables)
  //  }
  
  func getFollowedPosts() {
    if let userEmail = Auth.auth().currentUser?.email {
      Firestore.firestore().collection("Users")
        .document(userEmail)
        .collection("Following")
        .addSnapshotListener { snapshots, error in
          if let error = error {
            self.errorMessage = error.localizedDescription
            self.isError = true
            self.isLoading = false
            print("error: \(error)")
          } else {
            if let snapshots = snapshots?.documents {
              //              var posts: [PostModel] = []
              self.followedPosts = []
              // get followed
              for snapshot in snapshots {
                let data = snapshot.data()
                if let email = data["email"] as? String {
                  Firestore.firestore().collection("Posts")
                    .whereField("email", isEqualTo: email)
                    .getDocuments { snapshots, error in
                      if let error = error {
                        self.errorMessage = error.localizedDescription
                        self.isError = true
                        self.isLoading = false
                        print("error: \(error)")
                      } else {
                        if let snapshots = snapshots?.documents {
                          for snapshot in snapshots {
                            let data = snapshot.data()
                            if let text = data["text"] as? String,
                               let sender = data["sender"] as? String,
                               let email = data["email"] as? String,
                               let date = data["date"] as? String {
                              let post = PostModel(id: UUID().uuidString, text: text, date: date, user: UserModel(id: UUID().uuidString, email: email, username: sender, photoUrl: nil))
                              self.followedPosts.append(post)
                            }
                          }
                        }
                      }
                    }
                }
              }
            }
          }
        }
    }
  }
  
  func getUserPosts() {
    if let userEmail = Auth.auth().currentUser?.email {
      // get user itself
      Firestore.firestore().collection("Posts")
        .whereField("email", isEqualTo: userEmail)
        .addSnapshotListener { snapshots, error in
          if let error = error {
            self.errorMessage = error.localizedDescription
            self.isError = true
            self.isLoading = false
            print("error: \(error)")
          } else {
            if let snapshots = snapshots?.documents {
              self.userPosts = []
              for snapshot in snapshots {
                let data = snapshot.data()
                if let text = data["text"] as? String,
                   let sender = data["sender"] as? String,
                   let email = data["email"] as? String,
                   let date = data["date"] as? String {
                  let post = PostModel(id: UUID().uuidString, text: text, date: date, user: UserModel(id: UUID().uuidString, email: email, username: sender, photoUrl: nil))
                  self.userPosts.append(post)
                }
              }
            }
          }
        }
    }
  }
  
  func sortPosts(_ models: [PostModel]) -> [PostModel] {
    let count = 0..<models.count
    let dateFormatter = DateFormatter()
    
    dateFormatter.dateFormat = "dd/MM/yy HH:mm"
    
    var convertedArray: [(String, String, Date, UserModel)] = []
    
    for i in count {
      if let date =  dateFormatter.date(from: models[i].date) {
        convertedArray.append((models[i].id, models[i].text, date, models[i].user))
      }
    }
    
    let ready = convertedArray.sorted(by:  { $0.2.compare($1.2) == .orderedDescending })
    
    // formate the date to be more simple
    let dateFormatterGet = DateFormatter()
    dateFormatterGet.dateFormat = "dd/MM/yy HH:mm"
    let dateFormatterPrint = DateFormatter()
    dateFormatterPrint.dateFormat = "dd/MM/yy"
    
    let final = ready.map { item in
      return PostModel(id: item.0,
                       text: item.1,
                       date: Date().getFormattedDate(format: "dd/MM/yy") == dateFormatterPrint.string(from: dateFormatterGet.date(from: dateFormatterGet.string(from: item.2)) ?? Date()) ?
                        (dateFormatterGet.date(from: dateFormatterGet.string(from: item.2)) ?? Date()).getFormattedDate(format: "HH:mm") :
                        dateFormatterPrint.string(from: dateFormatterGet.date(from: dateFormatterGet.string(from: item.2)) ?? Date()),
                       user: item.3)
    }
    
    return final
  }
  
  func linkToDetail<Content: View>(post: PostModel, @ViewBuilder content: () -> Content) -> some View {
    NavigationLink(destination: router.makeDetailView(post: post)) { content() }
  }
  
}
