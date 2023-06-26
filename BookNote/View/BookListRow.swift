//
//  BookListRow.swift
//  BookNote
//
//  Created by 강준영 on 2023/05/12.
//

import SwiftUI

struct BookListRow: View {
    @Binding var item: BookInfo
    
    init(item: Binding<BookInfo>) {
        self._item = item
    }
    
    var body: some View {
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
                padding()
                Text(item.author)
                    .font(.body)
            }
        }
    }
}

struct BookListRow_Previews: PreviewProvider {
    static var previews: some View {
        BookListRow(item: .constant(BookInfo.dummy()))
    }
}

extension BookInfo {
    static func dummy() -> BookInfo {
        var info = BookInfo()
        info.image =  "https://shopping-phinf.pstatic.net/main_3254108/32541084667.20230207162859.jpg"
        info.author = "신경숙"
        info.title = "작별 곁에서"
        return info
    }
}
