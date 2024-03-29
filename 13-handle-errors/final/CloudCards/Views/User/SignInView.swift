/// Copyright (c) 2021 Razeware LLC
///
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
///
/// The above copyright notice and this permission notice shall be included in
/// all copies or substantial portions of the Software.
///
/// Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
/// distribute, sublicense, create a derivative work, and/or sell copies of the
/// Software in any work that is designed, intended, or marketed for pedagogical or
/// instructional purposes related to programming, coding, application development,
/// or information technology.  Permission for such use, copying, modification,
/// merger, publication, distribution, sublicensing, creation of derivative works,
/// or sale is expressly withheld.
///
/// This project and source code may use libraries or frameworks that are
/// released under various Open-Source licenses. Use of those libraries and
/// frameworks are governed by their own individual licenses.
///
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.

import Firebase
import SwiftUI

struct SignInView: View {
  @State var email = ""
  @State var password = ""
  
  @State var showAlert = false
  @State var errorDescription: String?
  
  private func showError(error: Error) {
    errorDescription = error.localizedDescription
    showAlert = true
  }
  
  @ObservedObject var cardListViewModel: CardListView.Model
  
  var body: some View {
    ZStack {
      SignInBackgroundView()
      
      VStack(alignment: .center, spacing: 20) {
        Text("Sign In to Cloud Cards")
          .font(.largeTitle)
          .foregroundColor(Color("rw-dark"))
        
        UserInfoForm(email: $email, password: $password)
        
        VStack {
          Button {
            AuthenticationService.signIn(email: email, password: password) { _, error in
              if let error = error { showError(error: error) }
            }
          }
          label: { SignInButton() }
          
          Button {
            AuthenticationService.addNewUser(email: email, password: password) { authResult, error in
              if let error = error {
                showError(error: error)
              } else {
                if let userInfo = authResult?.additionalUserInfo,
                   userInfo.isNewUser {
                  cardListViewModel.addStarterCards()
                }
              }
            }
          }
          label: { SignUpButton() }
        }
        .disabled(email.isEmpty || password.count < 6)
        
        Spacer()
      }
      .padding()
      .alert(isPresented: $showAlert) {
        Alert(title: Text(errorDescription ?? "🙀"))
      }
    }
  }
}

struct SignInView_Previews: PreviewProvider {
  static var previews: some View {
    SignInView(cardListViewModel: CardListView.Model())
  }
}


// MARK: - User Info Form
struct UserInfoForm: View {
  @Binding var email: String
  @Binding var password: String
  
  var body: some View {
    VStack(alignment: .center, spacing: 20) {
      VStack(alignment: .leading, spacing: 10) {
        Text("Email")
          .foregroundColor(Color("rw-dark"))
        TextField("Enter your email", text: $email)
          .textFieldStyle(RoundedBorderTextFieldStyle())
          .keyboardType(.emailAddress)
      }
      
      VStack(alignment: .leading, spacing: 10) {
        Text("Password")
          .foregroundColor(Color("rw-dark"))
        TextField("Enter a password", text: $password)
          .textFieldStyle(RoundedBorderTextFieldStyle())
          .keyboardType(.default)
      }
    }
  }
}

// MARK: - Button Views
struct SignUpButton: View {
  @Environment(\.isEnabled) var isEnabled
  
  var body: some View {
    HStack {
      Spacer()
      Text("Sign Up")
        .foregroundColor(isEnabled ? .white : Color("grey-iron"))
      Spacer()
    }
    .padding()
    .background(
      Color("grey-lynch")
        .opacity(isEnabled ? 1 : 0.5)
    )
    .cornerRadius(15)
  }
}

struct SignInButton: View {
  @Environment(\.isEnabled) var isEnabled
  
  var body: some View {
    HStack {
      Spacer()
      Text("Sign In")
        .foregroundColor(isEnabled ? .white : Color("grey-iron"))
      Spacer()
    }
    .padding()
    .background(
      Color("blue-curious")
        .opacity(isEnabled ? 1 : 0.5)
    )
    .cornerRadius(15)
  }
}

// MARK: - Background View
struct SignInBackgroundView: View {
  var body: some View {
    ZStack(alignment: .bottom) {
      Color("grey-iron")
      Image(systemName: "cloud.fill")
        .resizable()
        .scaledToFit()
        .scaleEffect(1.2)
        .offset(y: 30)
        .foregroundColor(Color("blue-azure").opacity(0.1))
    }
    .ignoresSafeArea()
  }
}

