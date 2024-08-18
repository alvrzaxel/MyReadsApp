//
//  AsyncImageView.swift
//  MyReads
//
//  Created by Axel Álvarez Santos on 23/7/24.
//

import SwiftUI

struct AsyncImageView: View {
    let urlString: String
    @State private var isLoading: Bool = true
    @State private var isUrlEmpty: Bool = false
    
    var body: some View {
        let url = URL(string: urlString)
        let secureURL = convertToHTTPS(url: url)
        
        AsyncImage(url: secureURL) { phase in
            switch phase {
            case .empty:
                if isLoading {
                    ProgressView()
                        .onAppear {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                isLoading = false
                            }
                        }
                }
            case .success(let image):
                image
                    .resizable()
                    .onAppear {
                        isLoading = false
                    }
                
            case .failure(_):
                
                CustomRoundedRectangle(overlayText: "Failed to\nload\nimage", width: 70, height: 100)
                    .onAppear {
                        isLoading = false
                    }
                
            @unknown default:
                CustomRoundedRectangle(overlayText: "Unknown\nerror", width: 70, height: 100)
                    .onAppear {
                        isLoading = false
                    }
            }
        }
        
    }
    
    // Método para convertir URL de HTTP a HTTPS
    private func convertToHTTPS(url: URL?) -> URL? {
        guard var urlString = url?.absoluteString else { return nil }
        
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


