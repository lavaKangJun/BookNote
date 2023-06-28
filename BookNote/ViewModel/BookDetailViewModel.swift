//
//  BookDetailViewModel.swift
//  BookNote
//
//  Created by 강준영 on 2023/06/28.
//

import Foundation
enum BookStatus {
    case complete
    case reading
    case favorite
    case none
}

class BookDetailViewModel: ObservableObject {
    @Published var isFavorited = false
    @Published var showFavoriteView = false
    @Published var bookStatus: BookStatus = .none
    @Published var currentBookStatus: BookStatus = .none
    
    let bookInfo: BookInfo
    
    init(bookInfo: BookInfo) {
        self.bookInfo = bookInfo
        fetchFavoriteBooks()
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
            let myBook = MyBook(bookInfo: self.bookInfo, bookStatus: currentBookStatus)
        }
        showFavoriteView = false
    }
    
    private func delete() { }
    
    private func fetchFavoriteBooks() {
        let dummy = MyBook(bookInfo: self.bookInfo, bookStatus: .complete)
        let books: [MyBook] = [ dummy ]
        guard let myBook = books.first(where: { $0.bookInfo.isbn == bookInfo.isbn}) else { return }
        isFavorited = true
        bookStatus = myBook.bookStatus
        currentBookStatus = myBook.bookStatus
    }
}
