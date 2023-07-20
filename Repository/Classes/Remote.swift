//
//  Remote.swift
//  Repository
//
//  Created by 강준영 on 2023/07/20.
//

import Foundation
import Alamofire
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseCore

public protocol RemoteProtocol {
    func connectionToServer()
    func fetchBookList(parameters: [String: Any]) async throws -> Data
    
    func fetchBookList() async throws -> [MyBook]
    func fetchBook(isbn: String) async throws -> BookStatus
    func fetchBookCompltedInfo(isbn: String) async throws -> CompleteInfo
    
    func saveBook(_ book: MyBook)
    func saveBookCompletedInfo(_ info: CompleteInfo)
    
    func deleteBook(_ isbn: String)
    
    func saveBookMemo()
    func getBookMemo()
}

extension RemoteProtocol {
    public func connectionToServer() {
        FirebaseApp.configure()
    }
    
    public func fetchBookList(parameters: [String: Any]) async throws -> Data {
        return try await withCheckedThrowingContinuation{ continuation in
            AF.request(API.bookList.api, method: .get, parameters: parameters, headers: API.header)
                .validate(statusCode: 200..<300)
                .response { response in
                    switch response.result {
                    case let .success(data):
                        continuation.resume(returning: data!)
                    case let .failure(error):
                        continuation.resume(throwing: error)
                    }
                }
        }
    }

    public func fetchBookList() async throws -> [MyBook] {
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
    
    public func fetchBook(isbn: String) async throws -> BookStatus {
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
    
    public func fetchBookCompltedInfo(isbn: String) async throws -> CompleteInfo {
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
    
    public func saveBook(_ book: MyBook) {
        let db = Firestore.firestore()
        db.collection("books")
            .document(book.bookInfo.isbn)
            .setData(book.asDictionary())
    }
    
    public func saveBookCompletedInfo(_ info: CompleteInfo) {
        let db = Firestore.firestore()
        db.collection("books")
            .document(info.isbn)
            .collection("completeInfos")
            .document(info.isbn)
            .setData(info.asDictionary())
    }
    
    public func deleteBook(_ isbn: String) {
        let db = Firestore.firestore()
        
        db.collection("books")
            .document(isbn)
            .collection("completeInfos")
            .document(isbn)
            .delete()
        
        db.collection("books")
            .document(isbn)
            .delete()
        
    }
    
    public func saveBookMemo() { }
    public func getBookMemo() { }
}

extension Encodable {
    func asDictionary() -> [String: Any] {
        guard let data = try? JSONEncoder().encode(self) else { return [:] }
        do {
            let json = try JSONSerialization.jsonObject(with: data) as? [String: Any]
            return json ?? [:]
        } catch {
            return [:]
        }
    }
}
