//
//  LoginOthersView.swift
//  MyReads
//
//  Created by Axel Álvarez Santos on 22/7/24.
//

import SwiftUI

struct LoginOthersView: View {
    @ObservedObject var authenticationViewModel: AuthenticationViewModel
    
    var body: some View {
        VStack {
            VStack {
                Button {
                    authenticationViewModel.loginWithGoogle()
                } label: {
                    HStack {
                        Image(.iconGoogle)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 20, height: 20)
                        Text("Sign in with Google")
                    }
                }
                .frame(maxWidth: .infinity)
                .frame(height: 40)
                .background(.textBlancoNegro)
                .cornerRadius(10)
                .shadow(color: .textNegroBlanco, radius: 2)
                .padding(.vertical, 10)
                
                Button {
                    authenticationViewModel.loginWithGoogle()
                } label: {
                    HStack(alignment: .center) {
                        
                        Image(systemName: "apple.logo")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 20, height: 20)
                        Text("Sign in with Apple")
                    }
                }
                .frame(maxWidth: .infinity)
                .frame(height: 40)
                .background(.textBlancoNegro)
                .cornerRadius(10)
                .shadow(color: .textNegroBlanco, radius: 2)
                .padding(.vertical, 10)
                
            }
            .foregroundStyle(.textNegroBlanco)
            
            Spacer()
        }.frame(maxHeight: .infinity)
    }
}

#Preview {
    LoginOthersView(authenticationViewModel: AuthenticationViewModel())
}
