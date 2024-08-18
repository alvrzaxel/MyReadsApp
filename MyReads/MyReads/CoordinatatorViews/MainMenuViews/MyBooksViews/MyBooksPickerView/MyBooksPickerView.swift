//
//  MyBooksPickerView.swift
//  MyReads
//
//  Created by Axel Álvarez Santos on 4/8/24.
//

import SwiftUI

enum BookList: String, CaseIterable, Identifiable {
    case wantToRead = "Want to read"
    case read = "Read"
    case currentlyReading = "Currently"
    
    var id: String { rawValue }
    
    // Convierte el caso en un estado de libro correspondiente
    func toBookStatus() -> BookStatus {
        switch self {
        case .wantToRead:
            return .wantToRead
        case .read:
            return .read
        case .currentlyReading:
            return .currentlyReading
        }
    }
}




struct MyBooksPickerView: View {
    @ObservedObject var userProfileViewModel: UserProfileViewModel
    @Binding var selectedList: BookList
    @Namespace private var myBooksAnimation
    
    var body: some View {
        VStack(spacing: 0) {
            MyBooksPickerNavBar(selectedList: $selectedList, myBooksAnimation: myBooksAnimation)
            
            ScrollView(.vertical) {
                MyBooksPickerBooksList(userProfileViewModel: userProfileViewModel, selectedList: $selectedList)
            }
            .scrollIndicators(.never)
        }
        .padding(.horizontal, 20)
        
        
        
    }
    
}

#Preview {
    MyBooksPickerView(userProfileViewModel: UserProfileViewModel(), selectedList: .constant(.wantToRead))
}



