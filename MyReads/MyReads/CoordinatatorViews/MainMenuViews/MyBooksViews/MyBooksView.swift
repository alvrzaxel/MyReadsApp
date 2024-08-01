//
//  MyBooksView.swift
//  MyReads
//
//  Created by Axel Álvarez Santos on 25/7/24.
//

import SwiftUI

struct MyBooksView: View {
    
    var body: some View {
        ZStack {
            Color.backgroundGeneral.ignoresSafeArea()
            
            VStack {
                
            }
        }
        .safeAreaInset(edge: .top) {
            NavBarMyBooks()
        }

        
    }
}


struct NavBarMyBooks: View {
    var body: some View {
        VStack {
            Image(.iconBar)
                .resizable()
                .scaledToFit()
                .frame(height: 30)
                
        }
        .frame(maxWidth: .infinity, maxHeight: 50)
        .padding(.bottom, 10)
        .background(.backgroundGeneral.opacity(0.95))
        
        
    }
}


#Preview {
    MyBooksView()
}
