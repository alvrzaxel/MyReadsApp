//
//  CustomNav.swift
//  MyReads
//
//  Created by Axel Álvarez Santos on 27/7/24.
//

import SwiftUI

struct TabBar: Identifiable {
    var id = UUID()
    var iconname: String
    var tab: TabIcon
    var index: Int
}

let tabItems = [TabBar(iconname: "house", tab: .home, index: 0),
                TabBar(iconname: "book", tab: .book, index: 2),
                TabBar(iconname: "person", tab: .person, index: 4)
]

enum TabIcon: String {
    case home 
    case book
    case person
}

struct CustomTabView: View {
    @Binding var selectedTab: TabIcon
    @State var Xoffset = 0.0
    var body: some View {
        Spacer()
        VStack {
            HStack {
                ForEach(tabItems) { item in
                    Spacer()
                    Image(systemName: item.iconname)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 21, height: 21)
                        
                        .foregroundStyle(.colortext1)
                        .onTapGesture {
                            withAnimation(.bouncy) {
                                selectedTab = item.tab
                                Xoffset = CGFloat(item.index) * 70.0
                            }
                            
                        }
                    Spacer()
      
                }
                .frame(width: 46.6)
            }
            .padding(.top, 10)
            
            Spacer()
            
        }.frame(height: 60)
        
        
        .overlay(alignment: .bottomLeading) {
            Circle().frame(width: 6, height: 6).foregroundStyle(.colorAccentOrange)
                .offset(x: 66.5, y: -17)
                .offset(x: Xoffset)
        }
    }
}

#Preview {
    CustomTabView(selectedTab: .constant(.home))
}
