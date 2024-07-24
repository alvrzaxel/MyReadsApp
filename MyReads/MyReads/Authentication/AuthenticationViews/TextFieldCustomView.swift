//
//  TextFieldCustom.swift
//  MyReads
//
//  Created by Axel Álvarez Santos on 21/7/24.
//

import SwiftUI

struct TextFieldCustomView: View {
    @Binding var textFieldEmail: String
    @Binding var textFieldPassword: String
    @Binding var isForgetPassword: Bool
    var showForgetPassWord: Bool
    
    @State private var isSecure: Bool = true
    @State private var shoForgetPassWord = true
    
    @FocusState private var isEmailFieldFocused: Bool
    @FocusState private var isPasswordFieldFocused: Bool
    
    var body: some View {
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
            
            
            HStack(alignment: .center) {
                if isSecure {
                    SecureField(text: $textFieldPassword) {
                        Text("Password")
                            .font(.system(size: 14, weight: .thin))
                            .foregroundStyle(.authenticationTextField)
                    }
                    .padding(.top, 12)
                    .autocapitalization(.none)
                    .autocorrectionDisabled(true)
                    .focused($isPasswordFieldFocused)
                } else {
                    TextField(text: $textFieldPassword) {
                        Text("Password")
                            .font(.system(size: 14, weight: .thin))
                            .foregroundStyle(.authenticationTextField)
                    }
                    .padding(.top, 12)
                    .autocapitalization(.none)
                    .autocorrectionDisabled(true)
                    .focused($isPasswordFieldFocused)
                }
                
                Button(action: {
                    isSecure.toggle()
                    
                }) {
                    Image(systemName: isSecure ? "eye.slash" : "eye")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 20, height: 20)
                        .foregroundStyle(.authenticationEye)
                    
                }
                .tint(.textNegroBlanco.opacity(0.5))
                .padding(.bottom, -10)
                .padding(.trailing, 20)
                
            }
            
            ZStack(alignment: .leading) {
                Rectangle()
                    .fill(.authenticationRectangleDisabled)
                    .frame(width: 310)
                
                Rectangle()
                    .fill(isPasswordFieldFocused ? .authenticationRectangleEnabled : .clear)
                    .frame(width: isPasswordFieldFocused ? 310 : 0, alignment: .leading)
                    .animation(.easeInOut(duration: 0.5), value: isPasswordFieldFocused)
            }.frame(height: 2)
            
            if (showForgetPassWord) {
                HStack {
                    Spacer()
                    Button(action: {
                        isForgetPassword.toggle()
                    }) {
                        Text("Forget password?")
                            .padding(.vertical, 2)
                            .padding(.trailing, 4)
                            .font(.system(size: 10))
                            .foregroundStyle(.authenticationTitle2)
                    }
                }
            }
            
        }
    }
}

#Preview {
    TextFieldCustomView(textFieldEmail: .constant(""), textFieldPassword: .constant(""), isForgetPassword: .constant(false), showForgetPassWord: true)
}


