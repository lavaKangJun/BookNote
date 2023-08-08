//
//  BookNoteApp.swift
//  BookNote
//
//  Created by 강준영 on 2023/03/16.
//

import SwiftUI

@main
struct BookNoteApp: App {
    @StateObject private var myListViewModel = BookListViewModel(repository: Repository.factory())
    @StateObject private var searchViewModel = SearchBookViewModel(repository: Repository.factory())
    init() {
        Repository.factory().connectionToServer()
    }
    
    var body: some Scene {
        WindowGroup {
            TabView {
               SearchBookView(viewModel: searchViewModel)
                    .tabItem({
                        Image(systemName: "sparkle.magnifyingglass")
                        Text("Search")
                    })
                    .tag(0)
                    .navigationViewStyle(.stack)
                
                BookListView(viewModel: myListViewModel)
                    .tabItem({
                        Image(systemName: "books.vertical.fill")
                        Text("My List")
                    })
                    .tag(1)
                    .navigationViewStyle(.stack)
                
                MyBookMemo()
                    .tabItem({
                        Image(systemName: "note.text")
                        Text("Memo")
                    })
                    .tag(2)
            }
            .task {
                await myListViewModel.fetchBookList()
            }
            .tint(Color("Neptune"))
        }
    }
}


