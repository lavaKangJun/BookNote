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
            if viewModel.myBookList.isEmpty {
                EmptyBookListView()
                    .navigationTitle("My Book List 📚")
            } else {
                List {
                    ForEach($viewModel.bookList) { item in
                        NavigationLink(destination: BookDetailView(viewModel: BookDetailViewModel(bookInfo: item.wrappedValue))) {
//                            BookListRow(item: item.wrappedValue)
                        }
                    }
                }
                .searchable(text: $query)
                .navigationTitle("My Book List 📚")
            }
        }
    }
}

struct BookListView_Previews: PreviewProvider {
    static var previews: some View {
        BookListView(viewModel: BookListViewModel(repository: Repository()))
    }
}
