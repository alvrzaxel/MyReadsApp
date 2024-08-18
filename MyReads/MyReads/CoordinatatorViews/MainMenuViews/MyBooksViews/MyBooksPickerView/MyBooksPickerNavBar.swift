//
//  MyBooksPickerNavBar.swift
//  MyReads
//
//  Created by Axel Álvarez Santos on 4/8/24.
//

import SwiftUI

struct MyBooksPickerNavBar: View {
    @Binding var selectedList: BookList
    var myBooksAnimation: Namespace.ID
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(BookList.allCases, id: \.rawValue) { list in
                Text(list.rawValue)
                    .foregroundStyle(selectedList == list ? .colortext1 : .colortext5)
                    .animation(.snappy, value: selectedList)
                    .font(.system(size: 13, weight: .semibold))
                    .padding(.vertical, 6)
                    .frame(width: 110)
                    .background {
                        ZStack {
                            if selectedList == list {
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(.colorbackground3)
                                    .matchedGeometryEffect(id: "ACTIVETABMYBOOKS", in: myBooksAnimation)
                            }
                        }
                        .animation(.snappy, value: selectedList)
                    }
                    .contentShape(.rect)
                    .onTapGesture {
                        withAnimation(.bouncy) { selectedList = list }
                    }
            }
        }
        .frame(maxWidth: .infinity)
        .padding(8)
        .background {
            UnevenRoundedRectangle(topLeadingRadius: 10, bottomLeadingRadius: 0, bottomTrailingRadius: 0, topTrailingRadius: 10, style: .continuous)
                .fill(.colorbackground2)
        }
    }
}
