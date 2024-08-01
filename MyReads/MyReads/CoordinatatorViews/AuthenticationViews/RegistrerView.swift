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
            Color.backgroundGeneral.ignoresSafeArea()
            
            VStack {
                DismissView()
                Image(.imageAuthenticationView).resizable().frame(width: 200, height: 200)
                
                VStack(spacing: 25)  {
                    VStack(spacing: 10) {
                        HStack() {
                            Text("Welcome!")
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundStyle(.textPrimary)
                            Spacer()
                        }
                        HStack() {
                            Text("To get started, get your account.")
                                .font(.system(size: 14, weight: .light))
                                .foregroundStyle(.textSecondary)
                            Spacer()
                        }
                    }
                    
                    VStack(spacing: 14) {
                        TextFieldEmail(textFieldEmail: $textFieldEmail)
                        PasswordCheckedField(textFieldPassword: $textFieldPassword)
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

struct PasswordCheckedField : View {
    @Binding var textFieldPassword: String
    
    @State var checkMinChars: Bool = false
    @State var checkLetter: Bool = false
    @State var checPunctuacion: Bool = false
    @State var checkNumber: Bool = false
    @State var showPaswword: Bool = false
    
//    var profressColor: Color {
//        let containsLetters = textFieldPassword.rangeOfCharacter(from: .letters) != nil
//        let containsNumbers = textFieldPassword.rangeOfCharacter(from: .decimalDigits) != nil
//        let containsPunctuation = textFieldPassword.rangeOfCharacter(from: CharacterSet(charactersIn: "!@#%^&.")) != nil
//        
//        if containsLetters && containsNumbers && containsPunctuation && textFieldPassword.count >= 8 {
//            return Color.green
//        } else if containsLetters && !containsNumbers && !containsPunctuation {
//            return Color.red
//        } else if containsNumbers && !containsLetters && !containsPunctuation {
//            return Color.red
//        } else if containsLetters && containsNumbers && !containsPunctuation {
//            return Color.yellow
//        } else if containsLetters && containsNumbers && containsPunctuation {
//            return Color.blue
//        } else {
//            return .gray
//        }
//    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 18) {
            TextFieldPassword(textFieldPassword: $textFieldPassword)
                .onChange(of: textFieldPassword) { oldValue, newValue in
                    checkMinChars = newValue .count > 8
                    checkLetter = newValue.rangeOfCharacter(from: .letters) != nil
                    checkNumber = newValue.rangeOfCharacter(from: .decimalDigits) != nil
                    checPunctuacion = newValue.rangeOfCharacter(from: CharacterSet(charactersIn: "!@#%^&.")) != nil
                }
            
            VStack(alignment: .leading, spacing: 8) {
                CheckText(text: "Minimum 8 characters", check: $checkMinChars)
                CheckText(text: "At least one letter", check: $checkLetter)
                CheckText(text: "(!@#%^&.)", check: $checPunctuacion)
                CheckText(text: "Number", check: $checkNumber)
            }
        }
        
        
    }
}


struct CheckText: View {
    let text: String
    @Binding var check: Bool
    var body: some View {
        HStack {
            Image(systemName: check ? "checkmark.circle.fill" : "circle")
                .contentTransition(.symbolEffect)
                .foregroundStyle(check ? .textSecondary : .textTerciary)
            Text(text).font(.system(size: 14))
        }
        .foregroundColor(check ? .textSecondary : .textTerciary)
    }
}
