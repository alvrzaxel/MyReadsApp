//
//  CustomNavBarUserProfile.swift
//  MyReads
//
//  Created by Axel Álvarez Santos on 4/8/24.
//

import SwiftUI

struct CustomNavBarUserProfile: View {
    @Binding var showSettings: Bool
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
        .background(.colorbackground1.opacity(0.98))
        .overlay(alignment: .trailing) {
            Button(action: {
                withAnimation {
                    showSettings.toggle()
                }
            }, label: {
                Image(systemName: "gearshape")
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: 20)
                    .foregroundStyle(.customOrange5)
            })
            .offset(x: -30, y: -10)
        }
        
    }
        
}

#Preview {
    CustomNavBarUserProfile(showSettings: .constant(false), showChangeTheme: .constant(false))
}
