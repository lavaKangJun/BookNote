//
//  BookDetailView.swift
//  BookNote
//
//  Created by 강준영 on 2023/05/12.
//

import SwiftUI

struct BookDetailView: View {
    @Binding var item: BookInfo
    
    var body: some View {
        ScrollView {
            Text(item.title)
            Spacer()
            Text(item.author)
            Spacer()
            Text(item.description)
        }
    }
}

struct BookDetailView_Previews: PreviewProvider {
    static var previews: some View {
        BookDetailView(item: .constant(BookInfo()))
    }
}
