//
//  DismissView.swift
//  MyReads
//
//  Created by Axel Álvarez Santos on 20/7/24.
//

import SwiftUI

struct DismissView: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        HStack {
            Spacer()
            Button("Cancel") {
                dismiss()
            }
            .tint(.dismissButton)
            .padding(.trailing, 12)
            .padding(.top, 20)
            
        }
        .buttonStyle(.bordered)
        
    }
}

#Preview {
    DismissView()
}
