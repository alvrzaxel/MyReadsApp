//
//  ForgetPassword2.swift
//  MyReads
//
//  Created by Axel Álvarez Santos on 26/7/24.
//

import SwiftUI

struct ForgotView: View {
    @ObservedObject var authenticationViewModel: AuthenticationViewModel
    @State var textFieldEmail: String = ""
    @FocusState var isEmailFieldFocused: Bool
    
    var body: some View {
        ZStack {
            Color.authenticationBackground.ignoresSafeArea()
            
            VStack(spacing: 25) {
                VStack(spacing: 10) {
                    HStack() {
                        Text("Forgot you password?")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundStyle(.authenticationTitle)
                        Spacer()
                    }
                    HStack() {
                        Text("Enter you email address and we will share a link to create a newpassword.")
                            .font(.system(size: 14, weight: .light))
                            .foregroundStyle(.authenticationTitle2)
                        Spacer()
                    }
                }
                
                TextFieldEmail(textFieldEmail: $textFieldEmail)
                
                AuthenticationButton(title: "Send") {
                    authenticationViewModel.resetPassword(email: textFieldEmail)
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
                
            }
            .padding(.horizontal, 20)
            .frame(maxWidth: .infinity)
            
        }
        .onDisappear { authenticationViewModel.cleanAnyMessage() }
    }
}

#Preview {
    ForgotView(authenticationViewModel: AuthenticationViewModel())
}
