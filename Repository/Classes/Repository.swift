//
//  Repository.swift
//  Repository
//
//  Created by 강준영 on 2023/07/20.
//

import Foundation

public protocol RepositoryProtocol {
    var remote: RemoteProtocol { get }
    var cache: CacheProtocol { get }
    
    func connectionToServer()
    func fetchBookList(query: String) async throws -> BookList
    func saveBook(_ book: MyBook)
    func saveBookCompletedInfo(_ info: CompleteInfo)
    func getBook(isbn: String) async throws -> BookStatus
    func getBookCompltedInfo(isbn: String) async throws -> CompleteInfo
    func getBookList() async throws -> [MyBook]
    func deleteBook(_ isbn: String)
}

extension RepositoryProtocol {
    public func connectionToServer() {
        self.remote.connectionToServer()
    }
    
    public func fetchBookList(query: String) async throws -> BookList {
        var parameters: [String: Any] = [:]
        parameters["query"] = query
        return try await self.remote.fetchBookList(parameters: parameters).responseDecodable()
    }

    public func saveBook(_ book: MyBook) {
        self.remote.saveBook(book)
    }
    
    public func saveBookCompletedInfo(_ info: CompleteInfo) {
        self.remote.saveBookCompletedInfo(info)
    }
    
    public func getBook(isbn: String) async throws -> BookStatus {
        try await self.remote.fetchBook(isbn: isbn)
    }
    
    public func getBookCompltedInfo(isbn: String) async throws -> CompleteInfo {
        try await self.remote.fetchBookCompltedInfo(isbn: isbn)
    }
    
    public func getBookList() async throws -> [MyBook] {
        try await self.remote.fetchBookList()
    }
    
    public func deleteBook(_ isbn: String) {
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

