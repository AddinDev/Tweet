//
//  UploadView.swift
//  Tweet
//
//  Created by addin on 17/06/21.
//

import SwiftUI

struct UploadView: View {
  
  @Environment(\.presentationMode) var presentationMode
  
  @EnvironmentObject var user: Authentication
  
  @ObservedObject var presenter: UploadPresenter
  
  @State private var text = ""
  
  var body: some View {
    NavigationView {
      Group {
        if presenter.isLoading {
          loadingIndicator
        } else if presenter.isError {
          errorIndicator
        } else {
          content
        }
      }
      .animation(.linear)
      .navigationBarTitle("New Post", displayMode: .inline)
      .navigationBarItems(leading: cancelButton,
                          trailing: doneButton)
    }
  }
  
}

extension UploadView {
  
  var loadingIndicator: some View {
    VStack {
      Text("Loading...")
      ProgressView()
        .progressViewStyle(CircularProgressViewStyle())
    }
  }
  
  var errorIndicator: some View {
    Text(presenter.errorMessage)
      .foregroundColor(.red)
      .padding()
  }
  
  var content: some View {
    VStack {
      TextEditor(text: $text)
        .autocapitalization(.none)
        .disableAutocorrection(true)
      Spacer()
    }
  }
  
  var cancelButton: some View {
    Button(action: {
      UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
      self.presentationMode.wrappedValue.dismiss()
    }) {
      Text("cancel")
    }
  }
  
  var doneButton: some View {
    Button(action: {
      presenter.upload(user.user, text: text) {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        self.presentationMode.wrappedValue.dismiss()
      }
    }) {
      Text("done")
    }
  }
  
}
