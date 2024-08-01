//
//  HomeWelcome.swift
//  MyReads
//
//  Created by Axel Álvarez Santos on 31/7/24.
//

import SwiftUI

struct HomeWelcome: View {
    var name: String
    
    private func greeting(for hour: Int) -> String {
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
    
    // Obtén la hora actual
        private var currentHour: Int {
            Calendar.current.component(.hour, from: Date())
        }
    
    private var firstName: String {
            name.split(separator: " ").first.map(String.init) ?? ""
        }
    
    var body: some View {
        VStack(alignment: .leading) {
            
            HStack {
                Text(greeting(for: currentHour)).foregroundStyle(.textQuaternary)
                + Text(firstName)
            }
            .font(.system(size: 24, weight: .regular))
            .padding(.bottom, 10)
                
            Text("the best books")
                .foregroundStyle(.textQuaternary
                )
            HStack {
                Text("for /").foregroundStyle(.textQuaternary)
                Text("you").foregroundStyle(.textPrimary)
                Spacer()
            }
            
          
        }
        .frame(height: 220)
        .font(.system(size: 55, weight: .regular))
        .frame(maxWidth: .infinity)
        .padding(.horizontal)
        
    }
}

#Preview {
    HomeWelcome(name: "Axel Alvarez")
}
