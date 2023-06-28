//
//  BookDetailViewModel.swift
//  BookNote
//
//  Created by 강준영 on 2023/06/28.
//

import Foundation
import FirebaseFirestore

class BookDetailViewModel: ObservableObject {
    @Published var isFavorited = false
    @Published var showFavoriteView = false
    @Published var bookStatus: BookStatus = .none
    @Published var currentBookStatus: BookStatus = .none
    
    let bookInfo: BookInfo
    
    init(bookInfo: BookInfo) {
        self.bookInfo = bookInfo
        
        fetchBook()
    }
    
    func changeStatus(status: BookStatus) {
        if currentBookStatus == status {
            currentBookStatus = .none
        } else {
            currentBookStatus = status
        }
    }
    
    func saveBook() {
        if currentBookStatus == .none {
            delete()
        } else {
            let myBook = MyBook(isbn: self.bookInfo.isbn, bookInfo: self.bookInfo, bookStatus: currentBookStatus)
            let db = Firestore.firestore()
            db.collection("books")
                .document(myBook.bookInfo.isbn)
                .setData(myBook.asDictionary())
        }
        showFavoriteView = false
    }
    
    private func delete() { }
    
    
    private func fetchBook() {
        

    
        let db = Firestore.firestore()
        db.collection("books")
            .document(self.bookInfo.isbn).getDocument { [weak self] snapShot, error in
                guard let data = snapShot?.data(), error == nil else { return }
                DispatchQueue.main.async {
                    self?.isFavorited = true
                    guard
                        let statusStr = data["bookStatus"] as? String,
                        let bookStatus = BookStatus(rawValue: statusStr) else { return }
                    self?.bookStatus = bookStatus
                    self?.currentBookStatus = bookStatus
                }
            }
    }
}
