//
//  Cache.swift
//  BookNote
//
//  Created by 강준영 on 2023/05/20.
//

import Foundation

enum CacheError: Error {
    case canNotFind
}

protocol CacheProtocol { }

final class Cache: CacheProtocol { }
