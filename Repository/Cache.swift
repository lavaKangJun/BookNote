//
//  Cache.swift
//  BookNote
//
//  Created by 강준영 on 2023/05/20.
//

import Foundation

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
