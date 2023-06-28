//
//  Cache.swift
//  BookNote
//
//  Created by 강준영 on 2023/05/20.
//

import Foundation

enum UserDefaultKey {
    case book // 책저장, 상태저장
    case memo // isbn으로 책이랑 연결
}

protocol CacheProtocol {
    func getBookList()
    func saveBook()
    
    func saveBookMemo()
    func getBookMemo()
}


final class Cache {
    func getBookList() { }
    func saveBook() { }
    
    func saveBookMemo() { }
    func getBookMemo() { }
}
