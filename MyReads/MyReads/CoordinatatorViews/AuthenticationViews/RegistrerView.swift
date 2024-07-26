//
//  RegistrerView.swift
//  MyReads
//
//  Created by Axel Álvarez Santos on 20/7/24.
//

import SwiftUI

struct RegistrerView: View {
    @ObservedObject var authenticationViewModel: AuthenticationViewModel
    @State var textFieldEmail: String = ""
    @State var textFieldPassword: String = ""
    
    @FocusState private var isEmailFieldFocused: Bool
    @FocusState private var isPasswordFieldFocused: Bool
    
    
    var body: some View {
        ZStack {
            Color.authenticationBackground.ignoresSafeArea()
            
            VStack {
                DismissView()
                Image(.imageAuthenticationView).resizable().frame(width: 200, height: 200)
                
                VStack(spacing: 25)  {
                    VStack(spacing: 10) {
                        HStack() {
                            Text("Welcome!")
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundStyle(.authenticationTitle)
                            Spacer()
                        }
                        HStack() {
                            Text("To get started, get your account.")
                                .font(.system(size: 14, weight: .light))
                                .foregroundStyle(.authenticationTitle2)
                            Spacer()
                        }
                    }
                    
                    VStack(spacing: 12) {
                        TextFieldEmail(textFieldEmail: $textFieldEmail)
                        TextFieldPassword(textFieldPassword: $textFieldPassword)
                    }
                    
                    
                    AuthenticationButton(title: "Sign up") {
                        authenticationViewModel.createNewUser(email: textFieldEmail, password: textFieldPassword)
                    }
                    
                    if let message = authenticationViewModel.messageError {
                        Text(message)
                            .font(.system(size: 10, weight: .light))
                            .foregroundStyle(.red.opacity(0.7))
                            .padding(.top, 10)
                        
                    } else if let message = authenticationViewModel.messageAlert {
                        Text(message)
                            .font(.system(size: 10, weight: .light))
                            .foregroundStyle(.green.opacity(0.7))
                            .padding(.top, 10)
                    }
                    
                    Spacer()
                }
            }
            .padding(.horizontal, 30)
            .frame(maxWidth: .infinity)
        }
        .onAppear { authenticationViewModel.cleanAnyMessage() }
        .onDisappear { authenticationViewModel.cleanAnyMessage() }
        
    }
}

#Preview {
    RegistrerView(authenticationViewModel: AuthenticationViewModel())
}

struct AuthenticatioMessage {
    
    
}
