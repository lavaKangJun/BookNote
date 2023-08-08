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
        NavigationView {
            ZStack {
                if query.isEmpty && viewModel.bookList.isEmpty {
                    Text("Search history")
                } else {
                    List {
                        ForEach($viewModel.bookList) { item in
                            ZStack(alignment: .leading) {
                                NavigationLink {
                                    BookDetailView(viewModel: BookDetailViewModel(bookInfo: item.wrappedValue, repository: Repository()))
                                } label: {
                                    EmptyView()
                                }
                                .opacity(0)
                                
                                listRow(item.wrappedValue)
                            }
                            .listRowBackground(
                                RoundedRectangle(cornerRadius: 10)
                                    .background(.clear)
                                    .foregroundColor(Color("Gray"))
                                    .padding(EdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2))
                            )
                            .listRowSeparator(.hidden)
                        }
                    }
                }
            }
            .searchable(text: $query)
            .onSubmit(of:.search , {
                viewModel.searchBook(query)
            })
            .onChange(of: query, perform: { newValue in
                if query.isEmpty {
                    viewModel.resetBookList()
                }
            })
            .navigationTitle("Search Book 📚")
        }
    }
    
    func listRow(_ item: BookInfo) -> some View {
        HStack {
            AsyncImage(url: URL(string: item.image)) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 60, height: 60)
            } placeholder: { }
            VStack(alignment: .leading) {
                Text(item.title)
                    .lineLimit(1)
                    .font(.system(size: 14))
                    .bold()
                Text(item.author)
                    .font(.system(size: 12))
                    .foregroundColor(.secondary)
            }
        }
    }
}

struct CreateMyBookView_Previews: PreviewProvider {
    static var previews: some View {
        SearchBookView(viewModel: SearchBookViewModel.factory())
    }
}
