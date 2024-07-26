//
//  TextFieldPassword.swift
//  MyReads
//
//  Created by Axel Álvarez Santos on 26/7/24.
//

import SwiftUI

struct TextFieldPassword: View {
    @State private var isSecured: Bool = true
    @Binding var textFieldPassword: String
    @FocusState private var isPasswordFieldFocused: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            
            HStack {
                VStack {
                    if isSecured {
                        SecureField(text: $textFieldPassword) {
                            Text("Password")
                                .font(.system(size: 14, weight: .thin))
                                .foregroundStyle(.authenticationTextField)
                        }
                        .autocapitalization(.none)
                        .autocorrectionDisabled(true)
                        .focused($isPasswordFieldFocused)
                        
                    } else {
                        
                        TextField(text: $textFieldPassword) {
                            Text("Password")
                                .font(.system(size: 14, weight: .thin))
                                .foregroundStyle(.authenticationTextField)
                        }
                        .autocapitalization(.none)
                        .autocorrectionDisabled(true)
                        .focused($isPasswordFieldFocused)
                    }
                }
                

                SecuredPasswordButton(isSecured: $isSecured)
                
            }
            
            VStack {
                ZStack(alignment: .leading) {
                    HStack {
                        Rectangle()
                            .fill(.authenticationRectangleDisabled)
                            .frame(width: 330, alignment: .leading)
                        Spacer()
                    }
                    
                    HStack {
                        Rectangle()
                            .fill(isPasswordFieldFocused ? .authenticationRectangleEnabled : .clear)
                        
                            .frame(width: isPasswordFieldFocused ? 330 : 0, alignment: .leading)
                            .animation(.easeInOut(duration: 0.5), value: isPasswordFieldFocused)
                        Spacer()
                    }
                }.frame(height: 2)
            }
            
        }
        
    }
}

#Preview {
    TextFieldPassword(textFieldPassword: .constant(""))
}

import SwiftUI

struct SecuredPasswordButton: View {
    @Binding var isSecured: Bool
    
    var body: some View {
        VStack {
            Button(action: {
                isSecured.toggle()
                
            }) {
                Image(systemName: isSecured ? "eye.slash" : "eye")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 20, height: 20)
                    .foregroundStyle(.authenticationEye)
                
            }
            .tint(.textNegroBlanco.opacity(0.5))
            .padding(.trailing, 20)
        }
    }
}

#Preview {
    SecuredPasswordButton(isSecured: .constant(true))
}
