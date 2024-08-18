//
//  CustomNavBarMyBooks.swift
//  MyReads
//
//  Created by Axel Álvarez Santos on 4/8/24.
//

import SwiftUI

struct CustomNavBarMyBooks: View {
    @Binding var showChangeTheme: Bool
    var body: some View {
        VStack {
            Button(action: {
                showChangeTheme.toggle()
            }) {
                Image(.iconBar)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 30)
            }
            
        }
        .frame(maxWidth: .infinity, maxHeight: 40)
        .padding(.bottom, 10)
        .background(.colorbackground1.opacity(0.95))
        
        
    }
}

#Preview {
    CustomNavBarMyBooks(showChangeTheme: .constant(false))
}
