///// Copyright (c) 2021 Razeware LLC
///// 
///// Permission is hereby granted, free of charge, to any person obtaining a copy
///// of this software and associated documentation files (the "Software"), to deal
///// in the Software without restriction, including without limitation the rights
///// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
///// copies of the Software, and to permit persons to whom the Software is
///// furnished to do so, subject to the following conditions:
///// 
///// The above copyright notice and this permission notice shall be included in
///// all copies or substantial portions of the Software.
///// 
///// Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
///// distribute, sublicense, create a derivative work, and/or sell copies of the
///// Software in any work that is designed, intended, or marketed for pedagogical or
///// instructional purposes related to programming, coding, application development,
///// or information technology.  Permission for such use, copying, modification,
///// merger, publication, distribution, sublicensing, creation of derivative works,
///// or sale is expressly withheld.
///// 
///// This project and source code may use libraries or frameworks that are
///// released under various Open-Source licenses. Use of those libraries and
///// frameworks are governed by their own individual licenses.
/////
///// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
///// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
///// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
///// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
///// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
///// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
///// THE SOFTWARE.
//
//import Firebase
//import SwiftUI
//
//struct SignInView: View {
//  @State var email = ""
//  @State var password = ""
//  
//  @Environment(\.presentationMode) var presentationMode
//  
//  var body: some View {
//    VStack(alignment: .center, spacing: 20) {
//      Button {
//        AuthenticationService.signInAnonymously()
//        presentationMode.wrappedValue.dismiss()
//      }
//        label: { GuestSignInButton() }
//      
//      Divider()
//        .padding(.vertical)
//      
//      UserInfoForm(email: $email, password: $password)
//      
//      Button {
//        AuthenticationService.signIn(email: email, password: password)
//        presentationMode.wrappedValue.dismiss()
//      }
//        label: { SignInButton() }
//      .disabled(email.isEmpty || password.count < 6)
//      
//      Button {
//        AuthenticationService.addNewUser(email: email, password: password)
//        presentationMode.wrappedValue.dismiss()
//      }
//        label: { SignUpButton() }
//        .disabled(email.isEmpty || password.isEmpty)
//      
//      Spacer()
//    }
//  }
//}
//
//struct SignInView_Previews: PreviewProvider {
//  static var previews: some View {
//    SignInView()
//  }
//}
//
//
//// MARK: - User Info Form
//struct UserInfoForm: View {
//  @Binding var email: String
//  @Binding var password: String
//  
//  var body: some View {
//    VStack(alignment: .center, spacing: 20) {
//      VStack(alignment: .leading, spacing: 10) {
//        Text("Email")
//          .foregroundColor(Color("rw-dark"))
//        TextField("Enter your email", text: $email)
//          .textFieldStyle(RoundedBorderTextFieldStyle())
//          .keyboardType(.emailAddress)
//      }
//      
//      VStack(alignment: .leading, spacing: 10) {
//        Text("Password")
//          .foregroundColor(Color("rw-dark"))
//        TextField("Enter a password", text: $password)
//          .textFieldStyle(RoundedBorderTextFieldStyle())
//          .keyboardType(.default)
//      }
//    }
//  }
//}
//
//// MARK: - Button Views
//struct GuestSignInButton: View {
//  var body: some View {
//    HStack {
//      Spacer()
//      
//      Image(systemName: "cloud.fill")
//        .font(.title)
//        .foregroundColor(Color("grey-iron"))
//      
//      Text("Try Cloud Cards as a Guest!")
//        .foregroundColor(Color.white)
//      
//      Spacer()
//    }
//    .padding()
//    .background(Color("blue-curious"))
//    .cornerRadius(15)
//  }
//}
//
//struct SignUpButton: View {
//  @Environment(\.isEnabled) var isEnabled
//  
//  var body: some View {
//    HStack {
//      Spacer()
//      Text("Sign Up")
//        .foregroundColor(isEnabled ? .white : Color("grey-iron"))
//      Spacer()
//    }
//    .padding()
//    .background(
//      Color("grey-lynch")
//        .opacity(isEnabled ? 1 : 0.5)
//    )
//    .cornerRadius(15)
//  }
//}
//
//struct SignInButton: View {
//  @Environment(\.isEnabled) var isEnabled
//  
//  var body: some View {
//    HStack {
//      Spacer()
//      Text("Sign In")
//        .foregroundColor(isEnabled ? .white : Color("grey-iron"))
//      Spacer()
//    }
//    .padding()
//    .background(
//      Color("blue-curious")
//        .opacity(isEnabled ? 1 : 0.5)
//    )
//    .cornerRadius(15)
//  }
//}
//
//// MARK: - Background View
//struct SignInBackgroundView: View {
//  var body: some View {
//    ZStack(alignment: .bottom) {
//      Color("grey-iron")
//      Image(systemName: "cloud.fill")
//        .resizable()
//        .scaledToFit()
//        .scaleEffect(1.2)
//        .offset(y: 30)
//        .foregroundColor(Color("blue-azure").opacity(0.1))
//    }
//    .ignoresSafeArea()
//  }
//}
//
