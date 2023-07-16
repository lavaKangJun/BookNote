//
//  Repository.swift
//  BookNote
//
//  Created by 강준영 on 2023/05/04.
//

import Foundation
import Alamofire
import FirebaseFirestore
import FirebaseFirestoreSwift

enum API {
    case bookList
    
    var api: String {
        switch self {
        case .bookList:
            return "https://openapi.naver.com/v1/search/book.json"
        }
    }
    
    static var header: HTTPHeaders = [
        "X-Naver-Client-Id" : "4xdrx65q2K1XTYkSENhn",
        "X-Naver-Client-Secret" : "ZLdRi6prgE",
        "Content-Type" : "application/json"
    ]
}

class Repository {
    private let remote = Remote()
    private let cache = Cache()
    func handleResponse(data: Data?, response: URLResponse) {
        guard let _ = data, let response = response as? HTTPURLResponse,
              response.statusCode >= 200 && response.statusCode < 300 else {
            return
        }
    }
    
    func fetchBookList(query: String) async throws -> BookList {
        var parameters: [String: Any] = [:]
        parameters["query"] = query
        return try await self.remote.fetchBookList(parameters: parameters).responseDecodable()
    }

    func saveBook(_ book: MyBook) {
        self.remote.saveBook(book)
    }
    
    func saveBookCompletedInfo(_ info: CompleteInfo) {
        self.remote.saveBookCompletedInfo(info)
    }
    
    func getBook(isbn: String) async throws -> BookStatus {
        try await self.remote.fetchBook(isbn: isbn)
    }
    
    func getBookCompltedInfo(isbn: String) async throws -> CompleteInfo {
        try await self.remote.fetchBookCompltedInfo(isbn: isbn)
    }
    
    func getBookList() async throws -> [MyBook] {
        try await self.remote.fetchBookList()
    }
    
    func deleteBook(_ isbn: String) {
        self.remote.deleteBook(isbn)
    }
}

extension Data {
    func responseDecodable<T: Decodable>() throws -> T {
        do {
            return try JSONDecoder().decode(T.self, from: self)
        } catch {
            throw error
        }
    }
}

protocol RemoteProtocol {
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

class Remote: RemoteProtocol {
    func fetchBookList(parameters: [String: Any]) async throws -> Data {
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

    func fetchBookList() async throws -> [MyBook] {
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
    
    func fetchBook(isbn: String) async throws -> BookStatus {
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
    
    func fetchBookCompltedInfo(isbn: String) async throws -> CompleteInfo {
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
    
    func deleteBook(_ isbn: String) {
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
    
    func saveBookMemo() { }
    func getBookMemo() { }
}
