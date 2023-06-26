//
//  BookListViewModel.swift
//  BookNote
//
//  Created by 강준영 on 2023/05/02.
//

import Foundation
import Combine

extension BookInfo: Identifiable {
    var id: ObjectIdentifier {
        ObjectIdentifier(NSString(string: isbn))
    }
}

class BookListViewModel: ObservableObject {
    var repository: Repository
    @Published var myBookList: [BookList] = []
    @Published var bookList: [BookInfo] = []
    
    private var cancellables = Set<AnyCancellable>()
    
    init(repository: Repository) {
        self.repository = repository
        
//        self.observeTrigger()
    }
    
    func searchBook(_ text: String) {
        Task {
            let bookList = try? await self.repository.fetchBookList(query: text)
            await MainActor.run {
                self.bookList = bookList?.items ?? []
            }
        }
    }
    
    private func observeTrigger() {
//        self.$query
//            .sink { [weak self] query in
//                guard let self = self else { return }
//                Task {
//                    let bookList = try? await self.repository.fetchBookList(query: query)
//                    await MainActor.run {
//                        self.bookList = bookList?.items ?? []
//                    }
//                }
//            }.store(in: &cancellables)

        
//        // Combine
//        repository.fetchBookList(url: URL(string: "")!)
//            .receive(on: DispatchQueue.main)
//            sink { _ in
//
//            } receiveValue: { [weak self] bookList in
//                if let bookList = bookList {
//                    self?.bookList = bookList
//                }
//            }
//            .store(in: &cancellables)

    }
}


