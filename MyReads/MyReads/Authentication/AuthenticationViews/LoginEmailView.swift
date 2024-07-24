//
//  LoginEmailView.swift
//  MyReads
//
//  Created by Axel Álvarez Santos on 23/7/24.
//

import SwiftUI

struct LoginEmailView: View {
    @ObservedObject var authenticationViewModel: AuthenticationViewModel
    @State var textFieldEmail: String = ""
    @State var textFieldPassword: String = ""
    @State private var isSecure: Bool = true
    
    var body: some View {
        VStack {
            
            HStack {
                Text("Welcome Back!")
                    .font(.system(size: 18, weight: .semibold))
                    .padding(.bottom, 2)
                    .foregroundStyle(Color.authenticationTitle)
                Spacer()
            }
            
            HStack {
                Text("To get started, sign in to your account.")
                    .font(.system(size: 14, weight: .light))
                    .foregroundStyle(Color.authenticationTitle2)
                Spacer()
            }
            
            VStack {
                TextFieldCustomView(textFieldEmail: $textFieldEmail, textFieldPassword: $textFieldPassword)
                
                Button("Sign in") {
                    authenticationViewModel.login(email: textFieldEmail, password: textFieldPassword)
                }
                .frame(maxWidth: .infinity)
                .padding(10)
                .background(.authenticationButton)
                .cornerRadius(10)
                .foregroundColor(.textBlancoNegro)
                .padding(.top, 20)
                
                if let messageError = authenticationViewModel.messageError {
                    Text(messageError)
                        .font(.system(size: 10, weight: .light))
                        .foregroundStyle(.red)
                        .padding(.top, 10)
                }
            }
        }
    }
}
#Preview {
    LoginEmailView(authenticationViewModel: AuthenticationViewModel())
}
