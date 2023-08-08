//
//  BookListView.swift
//  BookNote
//
//  Created by 강준영 on 2023/05/04.
//

import SwiftUI

struct BookListView: View {
    @ObservedObject var viewModel: BookListViewModel
    @State var query = ""
    
    var body: some View {
        NavigationView {
            if viewModel.bookList.isEmpty {
                EmptyBookListView()
                    .navigationTitle("My Book List 📚")
            } else {
                List {
                    ForEach($viewModel.bookList) { item in
                        NavigationLink(destination: BookDetailView(viewModel: BookDetailViewModel(bookInfo: item.wrappedValue, repository: Repository()))) {
                            BookListRow(item: item.wrappedValue)
                        }
                    }
                }
                .navigationTitle("My Book List 📚")
            }
        }.task {
            await viewModel.fetchBookList()
        }
    }
}

struct BookListView_Previews: PreviewProvider {
    static var previews: some View {
        BookListView(viewModel: BookListViewModel(repository: Repository()))
    }
}
