//
//  BookDetailViewModel.swift
//  BookNote
//
//  Created by 강준영 on 2023/06/28.
//

import Foundation
import Repository

class BookDetailViewModel: ObservableObject {
    let bookInfo: BookInfo
    private let repository: RepositoryProtocol
    
    @Published var isFavorited = false
    @Published var showFavoriteView = false
    @Published var bookStatus: BookStatus = .none
    @Published var currentBookStatus: BookStatus = .none
    
    // completed
    @Published var completedDate: Date = Date()
    @Published var rating: Double = 3.0
    
    init(bookInfo: BookInfo, repository: RepositoryProtocol) {
        self.bookInfo = bookInfo
        self.repository = repository
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
            self.repository.saveBook(myBook)
            
            if currentBookStatus == .complete {
                let completeInfo = CompleteInfo(isbn: self.bookInfo.isbn,
                                                rating: self.rating,
                                                date: self.completedDate.timeIntervalSince1970)
                self.repository.saveBookCompletedInfo(completeInfo)
            }
            
            self.isFavorited = true
        }
        showFavoriteView = false
    }
    
    private func delete() {
        self.isFavorited = false
        self.repository.deleteBook(self.bookInfo.isbn)
    }
    
    
    func fetchBook() async {
        guard let status = try? await self.repository.getBook(isbn: self.bookInfo.isbn) else {
            await MainActor.run(body: {
                self.isFavorited = false
            })
            
            return
        }
        
        if status == .complete {
            guard let completionInfo = try? await self.repository.getBookCompltedInfo(isbn: self.bookInfo.isbn) else {
                return
            }
            await MainActor.run(body: {
                self.completedDate = Date(timeIntervalSince1970: completionInfo.date)
                self.rating = completionInfo.rating
            })
        }
        
        await MainActor.run(body: {
            self.isFavorited = true
            self.bookStatus = status
            self.currentBookStatus = status
        })
    }
}
