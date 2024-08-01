//
//  UserProfileDetailsView.swift
//  MyReads
//
//  Created by Axel Álvarez Santos on 29/7/24.
//

import SwiftUI
import PhotosUI

struct UserDetailsView: View {
    @ObservedObject var userProfileViewModel: UserProfileViewModel
    @State var selectedItem: PhotosPickerItem? = nil
    @State var profileImage: UIImage? = nil
    @State var showPicker: Bool = false
    @State var show: Bool = false
    
    
    var body: some View {
        VStack(spacing: 30) {
            
            HStack(spacing: 30) {
                if let profileImage = userProfileViewModel.profileImage {
                    UserImageView(profileImage: profileImage)
                } else {
                    UserEmptyImageView()
                }
                
                UserResumeView(user: userProfileViewModel.user)
            }
            
            UserProgressBar(userProfileViewModel: userProfileViewModel)
            Spacer()
        }
        
        
    }
}

struct UserImageView: View {
    var profileImage: UIImage
    
    var body: some View {
        Image(uiImage: profileImage).resizable().scaledToFill()
            .frame(width: 110, height: 110)
            .clipShape(.rect(cornerRadius: 110))
    }
}

struct UserEmptyImageView: View {
    var body: some View {
        Image(systemName: "person.circle.fill")
            .resizable()
            .frame(width: 110, height: 110)
            .foregroundStyle(.gray)
        
    }
}

struct UserResumeView: View {
    var user: UserModel
    
    var body: some View {
        VStack(alignment: .center, spacing: 15) {
            VStack {
                Text(user.displayName.firstTwoWords())
                    .lineLimit(1)
                    .font(.system(size: 24, weight: .light))
            }
            
            HStack {
                VStack(alignment: .center) {
                    Text("\(user.bookCount)")
                        .font(.system(size: 25))
                        .bold()
                    
                    Text("Books".uppercased())
                        .font(.system(size: 12))
                        .foregroundColor(.gray)
                        .padding(.horizontal, 10)
                }
                
                VStack(alignment: .center) {
                    Text("\(user.readBookCount)")
                        .font(.system(size: 25))
                        .bold()
                    
                    Text("Read".uppercased())
                        .font(.system(size: 12))
                        .foregroundColor(.gray)
                        .padding(.horizontal, 10)
                }
                
                VStack(alignment: .center) {
                    Text("\(user.wantBookCount)")
                        .font(.system(size: 25))
                        .bold()
                    
                    Text("Want".uppercased())
                        .font(.system(size: 12))
                        .foregroundColor(.gray)
                        .padding(.horizontal, 10)
                }
            }
        }
    }
}

struct UserProgressBar: View {
    @ObservedObject var userProfileViewModel: UserProfileViewModel
    var currentYear: Int { Calendar.current.component(.year, from: Date()) }
    var year: String = String(Calendar.current.component(.year, from: Date()))
    var booksReadThisYear: Int {
        userProfileViewModel.readBooks.filter { book in
            let bookYear = Calendar.current.component(.year, from: book.creationDate)
            return bookYear == currentYear
        }.count
    }
    
    var body: some View {
        let year = String(currentYear)
        
        VStack(alignment: .leading, spacing: 10) {
            Text("\(year) Reading Goal")
                .font(.system(size: 12, weight: .semibold))
            
            HStack(spacing: 15) {
                Text("Progress")
                    .font(.system(size: 12))
                
                ProgressView(value: min(Double(booksReadThisYear), Double(userProfileViewModel.user.yearlyReadingGoal)), total: Double(userProfileViewModel.user.yearlyReadingGoal))
                    .tint(.customOrange3)
                
                Text("\(booksReadThisYear)/\(userProfileViewModel.user.yearlyReadingGoal)")
                    .font(.system(size: 12))
            }
        }
        .padding(.horizontal, 10)
    }
}

extension String {
    func firstTwoWords() -> String {
        let words = self.split(separator: " ")
        let firstTwo = words.prefix(2)
        return firstTwo.joined(separator: " ")
    }
}


#Preview {
    let exampleUser = UserModel(
        uid: "1234",
        displayName: "Axel Alvarez",
        email: "axel@gmail.com",
        emailVerified: true,
        photoURL: "https://lh3.googleusercontent.com/a/ACg8ocIU-w-m16GR3-CJRDSi9sh3OY01pzc9Ixoi5rUu18gWEwhhN-4F=s256-c",
        providerID: "google.com",
        creationDate: Date(),
        books: [],
        yearlyReadingGoal: 10
    )
    
    let viewModel = UserProfileViewModel()
    viewModel.user = exampleUser
    
    return UserDetailsView(userProfileViewModel: viewModel)
}


#Preview {
    UserDetailsView(userProfileViewModel: UserProfileViewModel())
}
