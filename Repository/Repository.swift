//
//  Repository.swift
//  BookNote
//
//  Created by 강준영 on 2023/05/04.
//

import Foundation

protocol RepositoryProtocol {
    var remote: RemoteProtocol { get set }
    
    func connectionToServer()
    func fetchBookList(query: String) async throws -> BookList
    
    func getBookList() async throws -> [MyBook]
    func getBook(isbn: String) async throws -> BookStatus
    func getBookCompltedInfo(isbn: String) async throws -> CompleteInfo
    
    func saveBook(_ book: MyBook)
    func saveBookCompletedInfo(_ info: CompleteInfo)
    
    func deleteBook(_ isbn: String)
    
//    func saveBookMemo()
//    func getBookMemo()
}

extension RepositoryProtocol {
    func connectionToServer() {
        self.remote.connectionToServer()
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

class Repository: RepositoryProtocol {
    var remote: RemoteProtocol = Remote()
}

extension Repository {
    static func factory() -> Repository {
        return Repository()
    }
}
