//
//  CustomTabBarView.swift
//  MyReads
//
//  Created by Axel Álvarez Santos on 4/8/24.
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

struct CustomTabBarView: View {
    @Binding var selectedTab: TabIcon
    @State var Xoffset = 0.0
    var body: some View {
        Spacer()
        HStack {
            ForEach(tabItems) { item in
                Spacer()
                VStack {
                    Image(systemName: item.iconname)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 20, height: 20)
                        .foregroundStyle(.colortext1)
                        .onTapGesture {
                            withAnimation(.bouncy) {
                                selectedTab = item.tab
                                Xoffset = CGFloat(item.index) * 70.0
                            }
                            
                        }
                    Spacer(minLength: 0)
                }
                .frame(height: 40)
                .padding(.top, 3)
                Spacer()
  
            }
            .frame(width: 46.6)
        }
        .frame(height: 60)
        
        .overlay(alignment: .bottomLeading) {
            Circle().frame(width: 6, height: 6).foregroundStyle(.customOrange7)
                .offset(x: 66.5, y: -16)
                .offset(x: Xoffset)
        }
    }
}

#Preview {
    CustomTabBarView(selectedTab: .constant(.home))
}
