//
//  BookList.swift
//  Repository
//
//  Created by 강준영 on 2023/07/20.
//

public struct BookList: Decodable {
    public let total: Int
    public let start: Int
    public let display: Int
    public let items: [BookInfo]
    
    enum CodingKeys: String, CodingKey {
        case total
        case start
        case display
        case items
    }
}

public struct BookInfo: Codable {
    public var title: String
    public var link: String
    public var image: String
    public var author: String
    public var discount: String
    public var publisher: String
    public var pubdate: String
    public var isbn: String
    public var description: String
    
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
    
    public init() {
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

public enum BookStatus: String, Codable {
    case complete
    case reading
    case favorite
    case none
}

public struct MyBook: Codable {
    public var isbn: String
    public var bookInfo: BookInfo
    public var bookStatus: BookStatus
    
    public init(isbn: String, bookInfo: BookInfo, bookStatus: BookStatus) {
        self.isbn = isbn
        self.bookInfo = bookInfo
        self.bookStatus = bookStatus
    }
}

public struct CompleteInfo: Codable {
    public var isbn: String
    public var rating: Double
    public var date: TimeInterval
    
    public init(isbn: String, rating: Double, date: TimeInterval) {
        self.isbn = isbn
        self.rating = rating
        self.date = date
    }
}
