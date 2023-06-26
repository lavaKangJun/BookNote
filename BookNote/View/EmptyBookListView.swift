//
//  EmptyBookListView.swift
//  BookNote
//
//  Created by 강준영 on 2023/05/20.
//

import SwiftUI
 
struct EmptyBookListView: View {
    var body: some View {
        ScrollView {
            Spacer(minLength: 100)
            VStack(spacing: 10) {
                Text("There are no items!")
                    .font(.title)
                    .fontWeight(.semibold)
                Text("Make My Book List")
                    .padding(.bottom, 20)
                NavigationLink(destination: SearchBookView(viewModel: SearchBookViewModel.factory())) {
                    Text("Add My Book")
                        .foregroundColor(.white)
                        .font(.headline)
                        .frame(height: 55)
                        .frame(maxWidth: .infinity)
                        .background(Color.accentColor)
                        .cornerRadius(10)
                }
                .padding(.horizontal, 50)
            }
            .frame(maxWidth: 400)
            .multilineTextAlignment(.center)
            .padding(40)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct EmptyBookListView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            EmptyBookListView()
                .navigationTitle("Title")
        }
    }
}
