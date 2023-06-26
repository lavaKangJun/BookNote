//
//  BookNoteApp.swift
//  BookNote
//
//  Created by 강준영 on 2023/03/16.
//

import SwiftUI

@main
struct BookNoteApp: App {
    @StateObject private var viewModel = BookListViewModel(repository: Repository())
    
    var body: some Scene {
        WindowGroup {
            TabView {
                BookListView(viewModel: viewModel)
                    .tabItem({
                        Image(systemName: "books.vertical.fill")
                        Text("List")
                    })
                    .tag(0)
                    .navigationViewStyle(.stack)
                
                MyBookMemo()
                    .tabItem({
                        Image(systemName: "note.text")
                        Text("Memo")
                    })
                    .tag(1)
            }
        }
    }
}


