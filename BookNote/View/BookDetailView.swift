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
            headerImage

            subscription
            .padding(EdgeInsets(top: 2, leading: 10, bottom: 2, trailing: 10))
            .frame(maxWidth: .infinity)
            
            spacing(height: 30)
            
            Button {
                // save
            } label: {
                Text("담기")
                    .bold()
            }
            .frame(width: 300, height: 50)
            .foregroundColor(.white)
            .background(Color.accentColor)
            .cornerRadius(10)

        }
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct BookDetailView_Previews: PreviewProvider {
    static var previews: some View {
        BookDetailView(item: .constant(BookInfo()))
    }
}

extension BookDetailView {
    var headerImage: some View {
        ZStack {
            AsyncImage(url: URL(string: item.image)) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 150, height: 150)
            } placeholder: {
            }
        }
        .frame(height: 200)
        .frame(maxWidth: .infinity)
        .background {
            Color("Gray")
        }
    }
    
    var subscription: some View {
        VStack(alignment: .leading) {
            Text(item.title)
                .font(.title3)
                .bold()
            
            spacing(height: 20)
            
            HStack(spacing: 10) {
                Text("저자")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                Text(item.author)
                    .font(.subheadline)
                
                spacing(width: 20)
                
                Text("출판사")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                Text(item.publisher)
                    .font(.subheadline)
            }
            
            spacing(height: 10)
            
            HStack(spacing: 10) {
                Text("발행")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                Text(item.pubdate)
                    .font(.subheadline)
            }
            
            spacing(height: 30)
            
            Text(item.description)
                .lineLimit(20)
                .font(.system(size: 15))
        }
    }
    
    func spacing(height: CGFloat) -> some View {
        Spacer()
            .frame(height: height)
    }
    
    func spacing(width: CGFloat) -> some View {
        Spacer()
            .frame(width: width)
    }
}
