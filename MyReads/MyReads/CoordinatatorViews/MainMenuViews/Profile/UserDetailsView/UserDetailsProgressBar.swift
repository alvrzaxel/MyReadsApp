//
//  UserProgressBar.swift
//  MyReads
//
//  Created by Axel Álvarez Santos on 4/8/24.
//

import SwiftUI

struct UserDetailsProgressBar: View {
    @ObservedObject var userProfileViewModel: UserProfileViewModel
    var currentYear: Int { Calendar.current.component(.year, from: Date()) }
    var year: String = String(Calendar.current.component(.year, from: Date()))
    var booksReadThisYear: Int {
            userProfileViewModel.user.books.filter { book in
                let bookYear = Calendar.current.component(.year, from: book.creationDate)
                return book.bookStatus == .read && bookYear == currentYear
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
                    .tint(.colorAccentOrange)
                
                Text("\(booksReadThisYear)/\(userProfileViewModel.user.yearlyReadingGoal)")
                    .font(.system(size: 12))
            }
        }
        .padding(.horizontal, 26)
        
    }
}
