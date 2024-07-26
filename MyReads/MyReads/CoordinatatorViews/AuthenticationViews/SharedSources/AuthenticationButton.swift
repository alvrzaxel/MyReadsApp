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
            Text(title).foregroundStyle(.textBlancoNegro)
                .frame(maxWidth: .infinity)
                .frame(height: 40)
                .background(.registrerButton, in: .rect(cornerRadius: 10))
        })
    }
}

#Preview {
    AuthenticationButton(title: "Botón!", action: {})
}
