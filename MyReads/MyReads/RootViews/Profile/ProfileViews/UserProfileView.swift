//
//  UserProfile.swift
//  MyReads
//
//  Created by Axel Álvarez Santos on 21/7/24.
//

import SwiftUI

struct UserProfileView: View {
    @ObservedObject var authenticationViewModel: AuthenticationViewModel
    @ObservedObject var userProfileViewModel: UserProfileViewModel
    
    @State private var isSettingsPresent: Bool = false
    
    var body: some View {
        NavigationStack {
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
            .background(Color(.systemBackground)) // Asegúrate de tener un fondo adecuado
            .navigationTitle("Profile")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        isSettingsPresent.toggle()
                    }, label: {
                        Image(systemName: "gearshape")
                            .foregroundStyle(.customOrange5)
                    })
                }
            }
            .sheet(isPresented: $isSettingsPresent, content: {
                UserSettingsView(authenticationViewModel: authenticationViewModel)
                
            })
//            .onAppear {
//                Task {
//                    await userProfileViewModel.loadCurrentUser()
//                }
//            }
        }
    }
}
#Preview {
    NavigationStack {
        UserProfileView(authenticationViewModel: AuthenticationViewModel(), userProfileViewModel: UserProfileViewModel())
        
    }
}


