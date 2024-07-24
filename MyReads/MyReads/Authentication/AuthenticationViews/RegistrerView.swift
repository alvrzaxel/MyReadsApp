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
        VStack {
            DismissView()
            
            VStack {
                Image(.imageAuthenticationView)
                    .resizable()
                    .frame(width: 200, height: 200)
                
                HStack {
                    Text("Welcome!")
                        .font(.system(size: 18, weight: .semibold))
                        .padding(.bottom, 2)
                        .foregroundColor(.registrerTitle)
                    Spacer()
                }
                
                HStack {
                    Text("To get started, get your account.")
                        .font(.system(size: 14, weight: .light))
                    Spacer()
                }
                
                VStack {
                    TextFieldCustomView(textFieldEmail: $textFieldEmail, textFieldPassword: $textFieldPassword, isForgetPassword: .constant(false), showForgetPassWord: false)
                    
                    Button("Sign up") {
                        authenticationViewModel.createNewUser(email: textFieldEmail, password: textFieldPassword)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(10)
                    .background(.registrerButton)
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
            }.padding(.horizontal, 40)
            
            Spacer()
        }
    }
}

#Preview {
    RegistrerView(authenticationViewModel: AuthenticationViewModel())
}
