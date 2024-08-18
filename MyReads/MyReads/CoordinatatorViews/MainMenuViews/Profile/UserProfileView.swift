//
//  UserProfile.swift
//  MyReads
//
//  Created by Axel Álvarez Santos on 21/7/24.
//

import SwiftUI

struct UserProfileView: View {
    @ObservedObject var userProfileViewModel: UserProfileViewModel
    @EnvironmentObject var authenticationViewModel: AuthenticationViewModel
    @State var showSettings: Bool = false
    @Binding  var showChangeTheme: Bool
    
    var body: some View {
        ZStack() {
            Color.colorbackground1.ignoresSafeArea()
            VStack {
                UserDetailsView(userProfileViewModel: userProfileViewModel)
                  
                Spacer()

            }
            .padding(.horizontal)
            .padding(.top, 10)
 
            
            
            
            
            
            
            
        }
        .safeAreaInset(edge: .top) {
            CustomNavBarUserProfile(showSettings: $showSettings, showChangeTheme: $showChangeTheme)
        }

        .fullScreenCover(isPresented: $showSettings,
                         onDismiss: { showSettings = false
        }, content: {
            UserProfileSettingsView3(userProfileViewModel: userProfileViewModel)
        })
        
        
    }
        
}



#Preview {
    let exampleUser = UserModel(
        uid: "1234",
        displayName: "Axel Alvarez",
        email: "axel@gmail.com",
        emailVerified: true,
        photoURL: "https://lh3.googleusercontent.com/a/ACg8ocIU-w-m16GR3-CJRDSi9sh3OY01pzc9Ixoi5rUu18gWEwhhN-4F=s256-c",
        providerID: "google.com",
        creationDate: Date(),
        books: [],
        yearlyReadingGoal: 1
    )
    
    let viewModel = UserProfileViewModel()
    viewModel.user = exampleUser
    
    return NavigationStack {
        UserProfileView(userProfileViewModel: viewModel, showChangeTheme: .constant(false))
    }
    .environmentObject(AuthenticationViewModel())
}







//struct UserProfileNavView: View {
//    @Binding var selectedView: UserProfileViews
//    var body: some View {
//        VStack {
//            Image(.iconBar)
//                .resizable()
//                .scaledToFit()
//                .frame(height: 35)
//                .padding(.vertical, 10)
//        }
//        .frame(maxWidth: .infinity)
//        .overlay(alignment: .trailing) {
//            HStack {
//                if selectedView == .userSettings {
//                    Button(action: {
//                        withAnimation(.spring) {
//                            selectedView = .userProfile
//                        }
//                        
//                    }, label: {
//                        Image(systemName: "arrow.left")
//                            .resizable()
//                            .scaledToFit()
//                            .frame(maxWidth: 20)
//                            .foregroundStyle(.customOrange5)
//                    }).padding(.horizontal)
//                }
//                
//                Spacer()
//                
//                Button(action: {
//                    withAnimation(.spring) {
//                        selectedView = .userSettings
//                    }
//                    
//                }, label: {
//                    Image(systemName: "gearshape")
//                        .resizable()
//                        .scaledToFit()
//                        .frame(maxWidth: 20)
//                        .foregroundStyle(.customOrange5)
//                }).padding(.horizontal)
//                
//            }
//        }
//    }
//}


//#Preview {
//    let exampleUser = UserModel(
//        uid: "1234",
//        displayName: "Axel Alvarez",
//        email: "axel@gmail.com",
//        emailVerified: true,
//        photoURL: "https://lh3.googleusercontent.com/a/ACg8ocIU-w-m16GR3-CJRDSi9sh3OY01pzc9Ixoi5rUu18gWEwhhN-4F=s256-c",
//        providerID: "google.com",
//        creationDate: Date(),
//        books: [],
//        yearlyReadingGoal: 1
//    )
//    
//    let viewModel = UserProfileViewModel()
//    viewModel.user = exampleUser
//    
//    return NavigationStack {
//        UserProfileView(userProfileViewModel: viewModel)
//    }
//    .environmentObject(AuthenticationViewModel())
//}


