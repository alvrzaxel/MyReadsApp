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
    var colorBackground: Color = .colorbackground3
    var colorText: Color = .colortext7
    var isItalic: Bool = true
    var isBold: Bool = false
    
    var body: some View {
        RoundedRectangle(cornerRadius: 6)
            .fill(colorBackground)
            .frame(width: width, height: height)
            .overlay {
                Text(overlayText)
                    .multilineTextAlignment(.center)
                    .lineSpacing(6)
                    .font(.system(size: 12))
                    .foregroundStyle(colorText)
                    .italic(isItalic)
                    .bold(isBold)
            }
    }
}
