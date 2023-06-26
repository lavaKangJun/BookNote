//
//  Factory.swift
//  BookNote
//
//  Created by 강준영 on 2023/06/14.
//

import Foundation


extension SearchBookViewModel {
    static func factory() -> SearchBookViewModel {
        return SearchBookViewModel(repository: Repository())
    }
}
