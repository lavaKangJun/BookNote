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
            
        }
        .searchable(text: $query) {
            ForEach(viewModel.bookList) { book in
                Li
                
            }
        }
        .onSubmit(of:.search , {
            viewModel.searchBook(query)
        })
        .navigationTitle("My Book List 📚")
    }
}

struct CreateMyBookView_Previews: PreviewProvider {
    static var previews: some View {
        SearchBookView(viewModel: SearchBookViewModel.factory())
    }
}
