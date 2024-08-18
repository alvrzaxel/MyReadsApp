//
//  UserDetailsImage.swift
//  MyReads
//
//  Created by Axel Álvarez Santos on 4/8/24.
//

import SwiftUI

struct UserDetailsImage: View {
    @Binding var profileImage: UIImage?
    
    var body: some View {
        if let profileImage = profileImage {
            Image(uiImage: profileImage).resizable().scaledToFill()
                .frame(width: 110, height: 110)
                .clipShape(.rect(cornerRadius: 110))
            
        } else {
            Image(systemName: "person.circle.fill")
                .resizable()
                .frame(width: 110, height: 110)
                .foregroundStyle(.gray)
        }
    }
}
