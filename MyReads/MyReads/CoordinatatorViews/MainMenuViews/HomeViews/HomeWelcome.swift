//
//  HomeWelcome.swift
//  MyReads
//
//  Created by Axel Álvarez Santos on 31/7/24.
//

import SwiftUI

struct HomeWelcome: View {
    var name: String
    
    // Saludo basado en la hora actual
    private var greeting: String {
        let hour = Calendar.current.component(.hour, from: Date())
        switch hour {
        case 0..<12:
            return "morning, "
        case 12..<17:
            return "afternoon, "
        case 17..<24:
            return "evening, "
        default:
            return "Hello, "
        }
    }
    
    // Obtiene el primer nombre
    private var firstName: String {
        name.split(separator: " ").first.map(String.init) ?? ""
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 50) {
            
            HStack {
                Text(greeting).foregroundStyle(.colortext9) +
                Text(firstName).foregroundStyle(.colortext2)
            }
            .font(.system(size: 20, weight: .regular))
            
            
            VStack(alignment: .leading) {
                Text("the best books")
                Text("for / ") +
                Text("you")
                    .foregroundStyle(.colortext4)
                    .fontWeight(.regular)
            }
            .font(.system(size: 50, weight: .bold))
            .foregroundStyle(.colortext11)
            
        }
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    HomeWelcome(name: "Axel Alvarez")
}
