//
//  UserResumeView.swift
//  MyReads
//
//  Created by Axel Álvarez Santos on 4/8/24.
//

import SwiftUI

struct UserDetailsResume: View {
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

extension String {
    func firstTwoWords() -> String {
        let words = self.split(separator: " ")
        let firstTwo = words.prefix(2)
        return firstTwo.joined(separator: " ")
    }
}
