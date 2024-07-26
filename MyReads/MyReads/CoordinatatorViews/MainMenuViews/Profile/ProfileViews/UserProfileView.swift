//
//  UserProfile.swift
//  MyReads
//
//  Created by Axel Álvarez Santos on 21/7/24.
//

import SwiftUI

struct UserProfileView: View {
    @ObservedObject var userProfileViewModel: UserProfileViewModel
    
    @State private var isSettingsPresent: Bool = false
    
    var body: some View {
        VStack {
            
            
            VStack {
                // Mostrar datos del usuario
                Text("Welcome \(userProfileViewModel.user?.email ?? "No Email")")
                    .padding(.top, 32)
                
                if let imageUrl = userProfileViewModel.user?.photoURL {
                    AsyncImageView(urlString: imageUrl)
                        .frame(maxWidth: 50)
                }
                
                /*
                 ForEach(userProfileViewModel.wantToReadBooks) { book in
                 if let imgURL = book.volumeInfo.imageLinks?.thumbnail {
                 AsyncImageView(urlString: imgURL)
                 }
                 }
                 */
            }
            
            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.generalBackground)
//        .toolbar {
//            ToolbarItem(placement: .navigationBarTrailing) {
//                Button(action: {
//                    isSettingsPresent.toggle()
//                }, label: {
//                    Image(systemName: "gearshape")
//                        .foregroundStyle(.customOrange5)
//                })
//            }
//        }
        .sheet(isPresented: $isSettingsPresent, content: {
            UserSettingsView(userProfileViewModel: userProfileViewModel)
            
        })
        .safeAreaInset(edge: .top) {
            ZStack {
                VStack(spacing: .zero) {
                    Image(.iconBar)
                        .resizable()
                        .scaledToFit()
                        .frame(height: 35)
                        .padding(.vertical, 10)
                    
                }
                
                Button(action: {
                    isSettingsPresent.toggle()
                }, label: {
                    Image(systemName: "gearshape")
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: 20)
                        .foregroundStyle(.customOrange5)
                })
                .offset(x: 160, y: -5)
            }
            
            
            
            
//            HStack {
//                Spacer()
//                VStack(spacing: .zero) {
//                    Image(.iconBar)
//                        .resizable()
//                        .scaledToFit()
//                        .frame(height: 35)
//                        .padding(.vertical, 10)
//                    
//                }
//                .background(.generalBackground.opacity(0.98))
//                Spacer()
//                Button(action: {
//                    isSettingsPresent.toggle()
//                }, label: {
//                    Image(systemName: "gearshape")
//                        .foregroundStyle(.customOrange5)
//                })
//                
//            }
            
            
            
          
            
        }
        
    }
}



#Preview {
    NavigationStack {
        UserProfileView(
            userProfileViewModel: UserProfileViewModel())
        
    }
}


