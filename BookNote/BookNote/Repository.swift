//
//  Repository.swift
//  BookNote
//
//  Created by 강준영 on 2023/07/20.
//

import Foundation
import Repository

final class Cache: CacheProtocol { }

final class Remote: RemoteProtocol { }

final class Repository: RepositoryProtocol {
    var remote: RemoteProtocol = Remote()
    var cache: CacheProtocol = Cache()
    
}
