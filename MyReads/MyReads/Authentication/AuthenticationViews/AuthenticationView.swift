//
//  ContentView.swift
//  MyReads
//
//  Created by Axel Álvarez Santos on 20/7/24.
//

import SwiftUI
import GoogleSignInSwift

struct AuthenticationView: View {
    @ObservedObject var authenticationViewModel: AuthenticationViewModel
    @State private var isShowingRegisterView: Bool = false
    
    var body: some View {
        
        VStack {
            
            Image(.imageAuthenticationView)
                .resizable()
                .frame(width: 200, height: 200)
            
            LoginEmailView(authenticationViewModel: authenticationViewModel)
            
            HStack {
                VStack { Divider() }
                Text("Or sign in with")
                    .font(.system(size: 14, weight: .light))
                    .foregroundStyle(.authenticationOrSign)
                VStack { Divider() }
            }.padding(.vertical, 35)
            
            LoginOthersView(authenticationViewModel: authenticationViewModel)
            
            //Spacer()
            
            HStack {
                Button {
                    isShowingRegisterView = true
                } label: {
                    Text("You do not have an account? Sign up.")
                        .foregroundStyle(.authenticationNoAccount)
                }
                .font(.system(size: 12, weight: .light))
                .tint(.textNegroBlanco)
                .padding(.bottom, 2)
                
            }
            .sheet(isPresented: $isShowingRegisterView) {
                RegistrerView(authenticationViewModel: authenticationViewModel)
                    .onAppear {
                        authenticationViewModel.cleanErrorMessage()
                    }
            }
            
        }
        .padding(.horizontal, 40)
        .frame(maxWidth: .infinity)
        
//        .alert(isPresented: $authenticationViewModel.showAlert) {
//                    Alert(title: Text("Error"), message: Text(authenticationViewModel.messageError ?? "Unknown error"), dismissButton: .default(Text("OK"), action: {
//                        authenticationViewModel.cleanErrorMessage()
//                    }))
        
        
    }
}
#Preview {
    AuthenticationView(authenticationViewModel: AuthenticationViewModel())
    
}
