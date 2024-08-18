//
//  LoginOthersView.swift
//  MyReads
//
//  Created by Axel Álvarez Santos on 22/7/24.
//

import SwiftUI

struct SigInOthersView: View {
    @ObservedObject var authenticationViewModel: AuthenticationViewModel
    var body: some View {
        VStack(spacing: 25) {
            Button(action: {
                authenticationViewModel.loginWithGoogle()
            }) {
                HStack(spacing: 12) {
                    Image(.iconGoogle)
                        .resizable()
                        .scaledToFit()
                        .frame(height: 20)
                    Text("Sign in with Google")
                        .font(.system(size: 14, weight: .light))
                        .foregroundStyle(.colortext2)
                }
            }
            .frame(maxWidth: .infinity)
            .frame(height: 40)
            .background(.colortextTotal)
            .cornerRadius(10)
            .shadow(color: .colortext2, radius: 1)
            
            Button(action: {
                //TODO
            }) {
                HStack(spacing: 12) {
                    Image(systemName: "apple.logo")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 20)
                        .foregroundStyle(.colorbackgroundTotal)
                    Text("Sign in with Apple")
                        .font(.system(size: 14, weight: .light))
                        .foregroundStyle(.colortext2)
                }
            }
            .frame(maxWidth: .infinity)
            .frame(height: 40)
            .background(.colortextTotal)
            .cornerRadius(10)
            .shadow(color: .colortext2, radius: 1)
        }
    }
}

#Preview {
    SigInOthersView(authenticationViewModel: AuthenticationViewModel())
}
