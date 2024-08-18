//
//  UserSettingsDetails.swift
//  MyReads
//
//  Created by Axel Álvarez Santos on 4/8/24.
//

import SwiftUI

struct UserSettingsDetails: View {
    @ObservedObject var userProfileViewModel: UserProfileViewModel
    var year: String = String(Calendar.current.component(.year, from: Date()))
    @State var newDisplayName: String = ""
    @State var newBooksGoal: String = ""
    
    @FocusState private var isDisplayNameFocused: Bool
    @FocusState private var isBooksGoalFocused: Bool
    
    var body: some View {
        VStack(spacing: 20) {
            VStack(spacing: 3) {
                HStack {
                    Text("User Name").font(.footnote).bold()
                    Spacer()
                }
                
                VStack(spacing: 2) {
                    TextField(text: $newDisplayName) {
                        Text(userProfileViewModel.user.displayName).font(.callout)
                    }
                    .focused($isDisplayNameFocused)
                    
                    Rectangle()
                        .fill(isDisplayNameFocused ? .colorbackground6 : .colorbackground4)
                        .animation(.easeInOut(duration: 0.3), value: isDisplayNameFocused)
                        .frame(maxWidth: .infinity)
                        .frame(height: 1)
                        .onSubmit {
                            userProfileViewModel.updateUserProfileProperty(property: .displayName(newDisplayName))
                        }
                }
            }
            
            
            VStack(spacing: 3) {
                HStack {
                    Text("Goal books read by \(year)").font(.footnote).bold()
                    Spacer()
                }
                
                VStack(spacing: 2) {
                    TextField(text: $newBooksGoal) {
                        Text(String(userProfileViewModel.user.yearlyReadingGoal)).font(.callout)
                    }
                    .onSubmit {
                        userProfileViewModel.updateUserProfileProperty(property: .yearlyReadingGoal(Int(newBooksGoal) ?? 0))
                        print("se hactualiza el goal 1")
                    }
                    .focused($isBooksGoalFocused)
                    Rectangle()
                        .fill(isBooksGoalFocused ? .colorbackground6 : .colorbackground4)
                        .animation(.easeInOut(duration: 0.3), value: isBooksGoalFocused)
                        .frame(maxWidth: .infinity)
                        .frame(height: 1)
                }
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 6)
        .padding(10)
        .background {
            RoundedRectangle(cornerRadius: 6)
                .fill(.colorbackground2)
        }
    }
}

#Preview {
    UserSettingsDetails(userProfileViewModel: UserProfileViewModel())
}
