//
//  BookListDto.swift
//  BookNote
//
//  Created by 강준영 on 2023/05/09.
//

import Foundation

struct BookList: Decodable {
    let total: Int
    let start: Int
    let display: Int
    let items: [BookInfo]
    
    enum CodingKeys: String, CodingKey {
        case total
        case start
        case display
        case items
    }
}

struct BookInfo: Codable {
    var title: String
    var link: String
    var image: String
    var author: String
    var discount: String
    var publisher: String
    var pubdate: String
    var isbn: String
    var description: String
    
    enum CodingKeys: String, CodingKey {
        case title
        case link
        case image
        case author
        case discount
        case publisher
        case pubdate
        case isbn
        case description
    }
    
    init() {
        self.title = ""
        self.link = ""
        self.image = ""
        self.author = ""
        self.discount = ""
        self.publisher = ""
        self.pubdate = ""
        self.isbn = ""
        self.description = ""
    }
}

enum BookStatus: String, Codable {
    case complete
    case reading
    case favorite
    case none
}

struct MyBook: Codable {
    var isbn: String
    var bookInfo: BookInfo
    var bookStatus: BookStatus
}
