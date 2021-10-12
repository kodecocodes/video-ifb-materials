/// Copyright (c) 2020 Razeware LLC
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

import Foundation

import FirebaseFirestore
import FirebaseFirestoreSwift
import Combine

class CardRepository: ObservableObject {
  private let store = Firestore.firestore()
  private let path = "cards"

  @Published var cards: [Card] = []

  var userID = ""
  let authService = AuthenticationService()

  private var cancellables: Set<AnyCancellable> = []

  init() {
    authService.$user
      .compactMap { user in
        user?.uid
      }
      .assign(to: \.userID, on: self)
      .store(in: &cancellables)

    authService.$user
      .receive(on: DispatchQueue.main)
      .sink { [weak self] _ in
        self?.get()
      }
      .store(in: &cancellables)
  }

  func get() {
    store.collection(path)
      .whereField("userID", in: [userID, ""])
      .addSnapshotListener { querySnapshot, error in
        if let error = error {
          print("Error getting cards: \(error.localizedDescription)")
          return
        }

        self.cards = querySnapshot?.documents.compactMap { document in
          try? document.data(as: Card.self)
        } ?? []
      }
  }

  func add(_ card: Card) {
    do {
      var newCard = card
      newCard.userID = userID
      _ = try store.collection(path).addDocument(from: newCard)
    } catch {
      fatalError("Unable to add card: \(error.localizedDescription).")
    }
  }

  func update(_ card: Card) {
    guard let cardId = card.id else { return }

    do {
      try store.collection(path).document(cardId).setData(from: card)
    } catch {
      fatalError("Unable to update card: \(error.localizedDescription).")
    }
  }

  func remove(_ card: Card) {
    guard let cardId = card.id else { return }

    store.collection(path).document(cardId).delete { error in
      if let error = error {
        print("Unable to remove card: \(error.localizedDescription)")
      }
    }
  }
}