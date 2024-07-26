//
//  ContentView.swift
//  MyReads
//
//  Created by Axel Álvarez Santos on 20/7/24.
//

import SwiftUI
import GoogleSignInSwift

struct AuthenticationView: View {
    @ObservedObject var authenticationViewModel: AuthenticationViewModel
    @State var showForgotView: Bool = false
    @State private var showSignUpView: Bool = false
    
    
    
    var body: some View {
        ZStack {
            Color.authenticationBackground.ignoresSafeArea()
            
            VStack {
                Image(.imageAuthenticationView).resizable().frame(width: 200, height: 200)
                
                SignInView(authenticationViewModel: authenticationViewModel, isForgetPassword: $showForgotView)
                
                HStack {
                    VStack { Divider() }
                    Text("Or sign in with")
                        .font(.system(size: 14, weight: .light))
                        .foregroundStyle(.authenticationOrSign)
                    VStack { Divider() }
                }.padding(.vertical, 35)
                
                SigInOthersView(authenticationViewModel: authenticationViewModel)
                
                Spacer()
                
                DontHaveAccount(showSignUpView: $showSignUpView)
                .sheet(isPresented: $showSignUpView) {
                    RegistrerView(authenticationViewModel: authenticationViewModel)
                        .onAppear { authenticationViewModel.cleanAnyMessage() }
                }
            }
            .padding(.horizontal, 30)
            .frame(maxWidth: .infinity)
            .sheet(isPresented: $showForgotView) {
                ForgotView(authenticationViewModel: authenticationViewModel)
                    .presentationDetents([.fraction(0.40)])
            }
        }
        .onDisappear {
            authenticationViewModel.getCurrentUser()
            authenticationViewModel.cleanAnyMessage()
        }
    }
}

struct DontHaveAccount: View {
    @Binding var showSignUpView: Bool
    
    var body: some View {
        HStack {
            Button {
                showSignUpView.toggle()
            } label: {
                Text("Don't have an account? Sign up")
                    .foregroundStyle(.authenticationNoAccount)
            }
            .font(.system(size: 12, weight: .light))
            .tint(.textNegroBlanco)
            .padding(.bottom, 2)

        }
    }
}




#Preview {
    AuthenticationView(authenticationViewModel: AuthenticationViewModel())
    
}
