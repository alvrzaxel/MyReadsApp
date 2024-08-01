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
    
    @State var checkMinChars: Bool = false
    @State var checkLetter: Bool = false
    @State var checPunctuacion: Bool = false
    @State var checkNumber: Bool = false
    @State var showPaswword: Bool = false
    
    var profressColor: Color {
        let containsLetters = textFieldPassword.rangeOfCharacter(from: .letters) != nil
        let containsNumbers = textFieldPassword.rangeOfCharacter(from: .decimalDigits) != nil
        let containsPunctuation = textFieldPassword.rangeOfCharacter(from: CharacterSet(charactersIn: "!@#%^&.")) != nil
        
        if containsLetters && containsNumbers && containsPunctuation && textFieldPassword.count >= 8 {
            return Color.green
        } else if containsLetters && !containsNumbers && !containsPunctuation {
            return Color.red
        } else if containsNumbers && !containsLetters && !containsPunctuation {
            return Color.red
        } else if containsLetters && containsNumbers && !containsPunctuation {
            return Color.yellow
        } else if containsLetters && containsNumbers && containsPunctuation {
            return Color.blue
        } else {
            return .gray
        }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            
            HStack {
                VStack {
                    if isSecured {
                        SecureField(text: $textFieldPassword) {
                            Text("Password")
                                .font(.system(size: 14, weight: .thin))
                                .foregroundStyle(.textFieldPlaceholder)
                        }
                        .autocapitalization(.none)
                        .autocorrectionDisabled(true)
                        .focused($isPasswordFieldFocused)
                        
                    } else {
                        
                        TextField(text: $textFieldPassword) {
                            Text("Password")
                                .font(.system(size: 14, weight: .thin))
                                .foregroundStyle(.textFieldPlaceholder)
                        }
                        .autocapitalization(.none)
                        .autocorrectionDisabled(true)
                        .focused($isPasswordFieldFocused)
                        .onChange(of: textFieldPassword) { oldValue, newValue in
                            withAnimation {
                                checkMinChars = newValue .count > 8
                                
                            }
                        }
                    }
                }
                

                SecuredPasswordButton(isSecured: $isSecured)
                
            }
            
            VStack {
                ZStack(alignment: .leading) {
                    HStack {
                        Rectangle()
                            .fill(.textFieldRectangleNotFocused
                            )
                            .frame(width: 330, alignment: .leading)
                        Spacer()
                    }
                    
                    HStack {
                        Rectangle()
                            .fill(isPasswordFieldFocused ? .textFieldRectangleFocused : .clear)
                        
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
                    .foregroundStyle(isSecured ? .textFieldPlaceholder : .textTerciary)
                
            }
            //.tint(.textNegroBlanco.opacity(0.5))
            .padding(.trailing, 20)
        }
    }
}

#Preview {
    SecuredPasswordButton(isSecured: .constant(true))
}
