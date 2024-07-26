//
//  MyBooksView.swift
//  MyReads
//
//  Created by Axel Álvarez Santos on 25/7/24.
//

import SwiftUI

struct MyBooksView: View {
    var body: some View {
        VStack {
            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.generalBackground)
        .safeAreaInset(edge: .top) {
            VStack(spacing: .zero) {
                Image(.iconBar)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 35)
                    .padding(.vertical, 10)
                
            }
            .background(.generalBackground.opacity(0.98))
            
        }
    }
}

#Preview {
    MyBooksView()
}

#Preview("Ligth") {
    NavigationStack {
        HomeView(userProfileViewModel: UserProfileViewModel(), googleApiViewModel: GoogleApiViewModel())
    }
}
