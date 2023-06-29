//
//  Repository.swift
//  BookNote
//
//  Created by 강준영 on 2023/05/04.
//

import Foundation
import Alamofire

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
        self.cache.saveBook(book)
    }
    
    func saveBookCompletedInfo(_ info: CompleteInfo) {
        self.cache.saveBookCompletedInfo(info)
    }
    
    func getBook(isbn: String) async throws -> BookStatus {
        try await self.cache.getBook(isbn: isbn)
    }
    
    func getBookCompltedInfo(isbn: String) async throws -> CompleteInfo {
        try await self.cache.getBookCompltedInfo(isbn: isbn)
    }
    
    func getBookList() async throws -> [MyBook] {
        try await self.cache.getBookList()
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

class Remote {
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
}
