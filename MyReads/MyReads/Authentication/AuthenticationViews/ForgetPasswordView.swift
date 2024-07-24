//
//  ForgetPasswordView.swift
//  MyReads
//
//  Created by Axel Álvarez Santos on 24/7/24.
//

import SwiftUI

struct ForgetPasswordView: View {
    @ObservedObject var authenticationViewModel: AuthenticationViewModel
    @State var textFieldEmail: String = ""
    @FocusState var isEmailFieldFocused: Bool
    @Binding var isForgetPassword: Bool
    
    var body: some View {
        VStack {
            Spacer()
            VStack {
                Text("Do not you remember your password?")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.registrerTitle)
                Text("Write your email and we will send you an email to change it")
                    .font(.system(size: 14, weight: .light))
                    .padding(.top, 10)
            }.frame(maxWidth: .infinity)
            
            VStack {
                TextField(text: $textFieldEmail) {
                    Text("Enter your email")
                        .font(.system(size: 14, weight: .thin))
                        .foregroundStyle(.authenticationTextField)
                }
                .padding(.top, 16)
                .keyboardType(.emailAddress)
                .autocapitalization(.none)
                .autocorrectionDisabled(true)
                .focused($isEmailFieldFocused)
                
                ZStack(alignment: .leading) {
                    Rectangle()
                        .fill(.authenticationRectangleDisabled)
                        .frame(width: 310)
                    
                    Rectangle()
                        .fill(isEmailFieldFocused ? .authenticationRectangleEnabled : .clear)
                        .frame(width: isEmailFieldFocused ? 310 : 0, alignment: .leading)
                        .animation(.easeInOut(duration: 0.5), value: isEmailFieldFocused)
                    
                }.frame(height: 2)
                
                Button("Send") {
                    //authenticationViewModel.resetPassword(email: textFieldEmail)
                    isForgetPassword.toggle()
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
            }.padding(.horizontal, 20)
            Spacer()
        }
        
        //.frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(.horizontal, 20)
        .background(.authenticationBackground)
        .onAppear {
            authenticationViewModel.cleanErrorMessage()
        }
    }
        
}

#Preview {
    ForgetPasswordView(authenticationViewModel: AuthenticationViewModel(), isForgetPassword: .constant(true))
}
