//
//  API.swift
//  Repository
//
//  Created by 강준영 on 2023/07/20.
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
