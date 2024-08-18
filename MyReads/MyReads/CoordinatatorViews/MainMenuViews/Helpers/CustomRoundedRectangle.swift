//
//  CustomRoundedRectangle.swift
//  MyReads
//
//  Created by Axel Álvarez Santos on 5/8/24.
//

import SwiftUI

struct CustomRoundedRectangle: View {
    var overlayText: String
    var width: CGFloat
    var height: CGFloat
    
    var body: some View {
        RoundedRectangle(cornerRadius: 6)
            .fill(.colorbackground3)
            .frame(width: width, height: height)
            .overlay {
                Text(overlayText)
                    .multilineTextAlignment(.center)
                    .lineSpacing(6)
                    .font(.footnote).italic()
                    .foregroundStyle(.colortext10)
            }
    }
}

#Preview {
    CustomRoundedRectangle(overlayText: "No books here", width: 350, height: 120)
}
