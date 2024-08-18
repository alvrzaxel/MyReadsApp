//
//  AuthenticationButton.swift
//  MyReads
//
//  Created by Axel Álvarez Santos on 26/7/24.
//

import SwiftUI

struct AuthenticationButton: View {
    var title: String
    var action:() -> Void
    
    var body: some View {
        Button(action: {action()}, label: {
            Text(title).foregroundStyle(.colortext14)
                .frame(maxWidth: .infinity)
                .frame(height: 40)
                .background(.colorbackground12, in: .rect(cornerRadius: 10))
        })
    }
}

#Preview {
    AuthenticationButton(title: "Botón!", action: {})
}
