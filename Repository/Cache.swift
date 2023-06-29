//
//  Cache.swift
//  BookNote
//
//  Created by 강준영 on 2023/05/20.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

enum CacheError: Error {
    case canNotFind
}

protocol CacheProtocol {
    func getBookList() async throws -> [MyBook]
    func getBook(isbn: String) async throws -> BookStatus
    func getBookCompltedInfo(isbn: String) async throws -> CompleteInfo
    
    func saveBook(_ book: MyBook)
    func saveBookCompletedInfo(_ info: CompleteInfo)
    
    func saveBookMemo()
    func getBookMemo()
}


final class Cache: CacheProtocol {
    func getBookList() async throws -> [MyBook] {
        try await withCheckedThrowingContinuation { continuation in
            let db = Firestore.firestore()
            db.collection("books")
                .getDocuments { snapshot, error in
                    if let error {
                        return continuation.resume(throwing: error)
                    }
                    
                    guard let documents = snapshot?.documents else {
                        return continuation.resume(throwing: CacheError.canNotFind)
                    }
                    
                    var result: [MyBook] = []
                    
                    documents.forEach { document in
                        do {
                            let json = try JSONSerialization.data(withJSONObject: document.data())
                            let decode = try JSONDecoder().decode(MyBook.self, from: json)
                            
                                result.append(decode)
                        } catch {
                            return continuation.resume(throwing: error)
                        }
                         
                    }
                    
                    return continuation.resume(returning: result)
                }
        }
    }
    
    func getBook(isbn: String) async throws -> BookStatus {
        try await withCheckedThrowingContinuation { continuation in
            let db = Firestore.firestore()
            db.collection("books")
                .document(isbn)
                .getDocument { snapShot, error in
                    if let error {
                        return continuation.resume(throwing: error)
                    }
                    
                    guard let data = snapShot?.data(),
                          let statusStr = data["bookStatus"] as? String,
                          let bookStatus = BookStatus(rawValue: statusStr) else {
                        return continuation.resume(throwing: CacheError.canNotFind)
                    }
                    
                    return continuation.resume(returning: bookStatus)
                }
        }
    }
    
    func getBookCompltedInfo(isbn: String) async throws -> CompleteInfo {
        try await withCheckedThrowingContinuation{ continuation in
            let db = Firestore.firestore()
            db.collection("books")
                .document(isbn)
                .collection("completeInfos")
                .document(isbn)
                .getDocument { snapShot, error in
                    if let error {
                        return continuation.resume(throwing: error)
                    }
                    
                    guard let data = snapShot?.data(),
                          let date = data["date"] as? TimeInterval,
                          let rating = data["rating"] as? Double else {
                        return continuation.resume(throwing: CacheError.canNotFind)
                    }
                    
                    return continuation.resume(returning: CompleteInfo(isbn: isbn, rating: rating, date: date))
                }
        }
    }
    
    func saveBook(_ book: MyBook) {
        let db = Firestore.firestore()
        db.collection("books")
            .document(book.bookInfo.isbn)
            .setData(book.asDictionary())
    }
    
    func saveBookCompletedInfo(_ info: CompleteInfo) {
        let db = Firestore.firestore()
        db.collection("books")
            .document(info.isbn)
            .collection("completeInfos")
            .document(info.isbn)
            .setData(info.asDictionary())
    }
    
    func saveBookMemo() { }
    func getBookMemo() { }
}
