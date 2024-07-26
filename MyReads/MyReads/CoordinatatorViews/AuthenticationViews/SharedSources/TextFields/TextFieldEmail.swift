//
//  TextFieldEmail.swift
//  MyReads
//
//  Created by Axel Álvarez Santos on 26/7/24.
//

import SwiftUI

struct TextFieldEmail: View {
    @Binding var textFieldEmail: String
    @FocusState private var isEmailFieldFocused: Bool
    
    var body: some View {
        
        VStack(spacing: 5) {
            VStack {
                TextField(text: $textFieldEmail) {
                    Text("Enter your email")
                        .font(.system(size: 14, weight: .thin))
                        .foregroundStyle(.authenticationTextField)
                }
                .keyboardType(.emailAddress)
                .autocapitalization(.none)
                .autocorrectionDisabled(true)
                .focused($isEmailFieldFocused)
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
                            .fill(isEmailFieldFocused ? .authenticationRectangleEnabled : .clear)
                        
                            .frame(width: isEmailFieldFocused ? 330 : 0, alignment: .leading)
                            .animation(.easeInOut(duration: 0.5), value: isEmailFieldFocused)
                        Spacer()
                    }
                }.frame(height: 2)
            }
        }
        
    }
}

#Preview {
    TextFieldEmail(textFieldEmail: .constant(""))
}
