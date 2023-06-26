//
//  CreateMyBookView.swift
//  BookNote
//
//  Created by 강준영 on 2023/05/20.
//

import SwiftUI

struct SearchBookView: View {
    @StateObject var viewModel: SearchBookViewModel
    @State var query: String = ""
    
    var body: some View {
        List {
            ForEach($viewModel.bookList) { item in
                NavigationLink(destination: BookDetailView(item: item)) {
                    listRow(item.wrappedValue)
                }
            }
        }
        .searchable(text: $query)
        .onSubmit(of:.search , {
            viewModel.searchBook(query)
        })
        .navigationTitle("My Book List 📚")
    }
    
    func listRow(_ item: BookInfo) -> some View {
        HStack {
            AsyncImage(url: URL(string: item.image)) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 60, height: 60)
            } placeholder: {
                ProgressView()
            }
            VStack(alignment: .leading) {
                Text(item.title)
                    .font(.headline)
                Text(item.author)
                    .font(.body)
            }
        }
    }
}

struct CreateMyBookView_Previews: PreviewProvider {
    static var previews: some View {
        SearchBookView(viewModel: SearchBookViewModel.factory())
    }
}
