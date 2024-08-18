//
//  CustomCoverImage.swift
//  MyReads
//
//  Created by Axel Álvarez Santos on 5/8/24.
//

import SwiftUI

struct CustomCoverImage: View {
    let imageUrl: String?
    
    var body: some View {
        if let urlImage = imageUrl {
            AsyncImageView(urlString: urlImage)
                .scaledToFill()
                .frame(width: 60, height: 90)
                .clipped()
                .cornerRadius(6)
        } else {
            CustomRoundedRectangle(overlayText: "Cover\nnot\nfound", width: 60, height: 90)
        }
    }
}

#Preview {
    CustomCoverImage(imageUrl: "https://m.media-amazon.com/images/I/71TQ+LBCU4L._AC_UF894,1000_QL80_.jpg")
}
