//
//  LoginEmailView.swift
//  MyReads
//
//  Created by Axel Álvarez Santos on 23/7/24.
//

import SwiftUI

struct SignInView: View {
    @ObservedObject var authenticationViewModel: AuthenticationViewModel
    @Binding var isForgetPassword: Bool
    
    @State var textFieldEmail: String = ""
    @State var textFieldPassword: String = ""
    
    
    var body: some View {
        VStack(spacing: 25) {
            
            VStack(spacing: 10) {
                HStack() {
                    Text("Welcome Back!")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundStyle(.colortext1)
                    Spacer()
                }
                HStack() {
                    Text("To get started, sign in to your account.")
                        .font(.system(size: 14, weight: .light))
                        .foregroundStyle(.colortext2)
                    Spacer()
                }
            }
            
            VStack(spacing: 14) {
                TextFieldEmail(textFieldEmail: $textFieldEmail)
                
                TextFieldPassword(textFieldPassword: $textFieldPassword)
                
                ButtonForgetPassword(isForgotPassword: $isForgetPassword)
            }
            
            AuthenticationButton(title: "Sign in") {
                authenticationViewModel.login(email: textFieldEmail, password: textFieldPassword)
            }
            
            if authenticationViewModel.showAlert,
                let message = authenticationViewModel.messageError {
                
                Text(message)
                    .font(.system(size: 10, weight: .ultraLight))
                    .foregroundStyle(.red)
                    .padding(.top, 10)
            }
            
        }
        .onDisappear {
            authenticationViewModel.cleanMessageError()
        }
    }
}

#Preview {
    SignInView(authenticationViewModel: AuthenticationViewModel(), isForgetPassword: .constant(false))
}


#Preview {
    SignInView(authenticationViewModel: AuthenticationViewModel(), isForgetPassword: .constant(false))
}


struct ButtonForgetPassword: View {
    @Binding var isForgotPassword: Bool
    
    var body: some View {
        HStack {
            Spacer()
            Button(action: {
                isForgotPassword.toggle()
            }) {
                Text("Forget password?")
                    .padding(.trailing, 10)
                    .padding(.top, 4)
                    .font(.system(size: 10))
                    .foregroundStyle(.colortext2)
            }
        }
    }
}
