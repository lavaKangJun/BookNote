//
//  SearchBookViewModel.swift
//  BookNote
//
//  Created by 강준영 on 2023/06/14.
//

import Foundation
import Combine

class SearchBookViewModel: ObservableObject {
    var repository: Repository
    @Published var myBookList: [BookList] = []
    @Published var bookList: [BookInfo] = []
    
    private var cancellables = Set<AnyCancellable>()
    
    init(repository: Repository) {
        self.repository = repository
    }
    
    func searchBook(_ text: String) {
        Task {
            let bookList = try? await self.repository.fetchBookList(query: text)
            await MainActor.run {
                self.bookList = bookList?.items ?? []
            }
        }
    }
    
    func resetBookList() {
        self.bookList = []
    }
    
//    private func observeTrigger() {
//        self.$query
//            .debounce(for: 0.5, scheduler: DispatchQueue.main)
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
//
//    }
}
