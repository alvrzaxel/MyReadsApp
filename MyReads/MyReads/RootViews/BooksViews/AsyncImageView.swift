//
//  AsyncImageView.swift
//  MyReads
//
//  Created by Axel Álvarez Santos on 23/7/24.
//

import SwiftUI

struct AsyncImageView: View {
    let urlString: String
    
    var body: some View {
        // Usa la URL convertida a HTTPS si es necesario
        let url = URL(string: urlString)
        let secureURL = convertToHTTPS(url: url)
        
        AsyncImage(url: secureURL) { phase in
            switch phase {
            case .empty:
                ProgressView() // Placeholder while the image is loading
            case .success(let image):
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            case .failure(_):
                Text("Failed to load image")
            @unknown default:
                Text("Unknown error")
            }
        }
        
    }
    
    // Método para convertir URL de HTTP a HTTPS
    private func convertToHTTPS(url: URL?) -> URL? {
        guard var urlString = url?.absoluteString else { return nil }
        
        // Reemplaza 'http' con 'https' si es necesario
        if urlString.hasPrefix("http://") {
            urlString = "https://" + urlString.dropFirst(7) // Remueve 'http://' y añade 'https://'
            return URL(string: urlString)
        }
        
        return url
    }
}

#Preview {
    AsyncImageView(urlString: "")
}
