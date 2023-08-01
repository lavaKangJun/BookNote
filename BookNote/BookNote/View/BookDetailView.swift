//
//  BookDetailView.swift
//  BookNote
//
//  Created by 강준영 on 2023/05/12.
//

import SwiftUI
import Repository

struct BookDetailView: View {
    @StateObject var viewModel: BookDetailViewModel
    var rating: [Double] = [0.5, 1.0, 1.5, 2.0, 2.5, 3.0, 3.5, 4.0, 4.5, 5.0]
    
    var body: some View {
        ScrollView {
            headerImage
            
            subscription
                .padding(EdgeInsets(top: 2, leading: 10, bottom: 2, trailing: 10))
                .frame(maxWidth: .infinity)
            
            spacing(height: 30)
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            Button {
                viewModel.showFavoriteView = true
            } label: {
                if viewModel.isFavorited {
                    Image(systemName: "heart.fill")
                        .foregroundColor(Color.accentColor)
                } else {
                    Image(systemName: "heart")
                        .foregroundColor(Color.accentColor)
                }
            }
        }
        .sheet(isPresented: $viewModel.showFavoriteView) {
            buttonSheet
                .presentationDetents([.height(330)])
        }
        .task {
            await viewModel.fetchBook()
        }
    }
}

struct BookDetailView_Previews: PreviewProvider {
    static var previews: some View {
        BookDetailView(viewModel: BookDetailViewModel(bookInfo: BookInfo(), repository: Repository()))
    }
}

extension BookDetailView {
    func roundButton(status: BookStatus, label: String, highlited: Bool) -> some View {
        Button {
            viewModel.changeStatus(status: status)
        } label: {
            HStack(spacing: 5) {
                if highlited {
                    Image(systemName: "checkmark")
                        .resizable()
                        .frame(width: 10, height: 10)
                }
                
                Text(label)
                    .font(.system(size: 13))
                    .bold()
            }
        }
        .frame(width: 100, height: 50)
        .foregroundColor(Color("Neptune"))
        .background(.clear)
        .cornerRadius(10)
        .overlay {
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color("Neptune"), lineWidth: 1)
        }
    }
    
    var buttonSheet: some View {
        VStack(spacing: 23) {
            Text("📖 상태를 설정해 주세요")
                .font(.system(size: 17))
                .bold()
                .foregroundColor(Color("Neptune"))
                .frame(width: 310, alignment: .leading)
      
            HStack(spacing: 10) {
                roundButton(status: .complete, label: "읽은 책이에요", highlited: viewModel.currentBookStatus == .complete)
                roundButton(status: .reading, label: "읽는 중이에요", highlited: viewModel.currentBookStatus == .reading)
                roundButton(status: .favorite, label: "읽고 싶어요", highlited: viewModel.currentBookStatus == .favorite)
            }
            
            if viewModel.currentBookStatus == .complete {
                
                DatePicker(selection: $viewModel.completedDate, displayedComponents: [.date]) {
                    Text("읽은 날짜")
                        .font(.system(size: 15))
                        .foregroundColor(.gray)
                }
                .frame(width: 300)
                
                HStack {
                    Text("평가")
                        .font(.system(size: 15))
                        .foregroundColor(.gray)
                    
                    Spacer()
                    
                    Picker("Rating", selection: $viewModel.rating) {
                        ForEach(rating, id: \.self) { value in
                            Text(String(format: "%.1f", value))
                        }
                    }
                }.frame(width: 300)
            }
            
            Button {
                viewModel.saveBook()
            } label: {
                Text("저장하기")
                    .font(.system(size: 13))
                    .bold()
            }
            .frame(width: 320, height: 50)
            .foregroundColor(.white)
            .background(Color("Neptune"))
            .cornerRadius(10)
        }
        
    }
    
    var headerImage: some View {
        ZStack {
            AsyncImage(url: URL(string: viewModel.bookInfo.image)) { image in
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
            Text(viewModel.bookInfo.title)
                .font(.title3)
                .bold()
            
            spacing(height: 20)
            
            HStack(spacing: 10) {
                Text("저자")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                Text(viewModel.bookInfo.author)
                    .font(.subheadline)
                
                spacing(width: 20)
                
                Text("출판사")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                Text(viewModel.bookInfo.publisher)
                    .font(.subheadline)
            }
            
            spacing(height: 10)
            
            HStack(spacing: 10) {
                Text("발행")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                Text(viewModel.bookInfo.pubdate)
                    .font(.subheadline)
            }
            
            spacing(height: 30)
            
            Text(viewModel.bookInfo.description)
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
