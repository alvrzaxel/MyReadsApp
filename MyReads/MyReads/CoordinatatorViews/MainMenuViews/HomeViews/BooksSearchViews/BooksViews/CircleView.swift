//
//  PlusView.swift
//  MyReads
//
//  Created by Axel Álvarez Santos on 26/7/24.
//

import SwiftUI

struct CircleView: View {
    @Binding var show: Bool
    
    var body: some View {
        RoundedRectangle(cornerRadius: show ? 16 : 40)
            .frame(width: show ? 125 : 50, height: show ? 210 : 50)
            .foregroundStyle(.authenticationTitle2)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomLeading)
            .padding(20)
            .onTapGesture {
                withAnimation(.snappy) {
                    show.toggle()
                }
            }
    }
}


struct PlusView:View {
    @State var show = false
    var body: some View {
        CircleView(show: $show)
            .overlay {
                ZStack {
                    if show {
                        VStack(alignment: .leading, spacing: 22.7) {
                            ButtonMenu(icon: "camera.fill", title: "Camera", action: {
                                withAnimation {
                                    show.toggle()
                                }
                            })
                            ButtonMenu(icon: "photo.fill.on.rectangle.fill", title: "Photos", action: {})
                            ButtonMenu(icon: "location.fill", title: "Location", action: {})
                            ButtonMenu(icon: "person.fill", title: "Contact", action: {})
                        }
                        .foregroundStyle(show ? .textNegroBlanco : .clear)
                    } else {
                        Image(systemName: "plus")
                            .foregroundColor(.white)
                            .padding(7)
                    }
                        
                }
                .clipped()
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomLeading)
                .padding(30)
            }
        
    }
}


struct ButtonMenu:View {
    var icon: String
    var title: String
    var action: () -> Void
    
    var body: some View {
        Button {
            action()
        } label: {
            HStack {
                Image(systemName: icon).font(.footnote)
                    .frame(width: 30, height: 30)
                    .background(.textBlancoNegro, in: Circle())
                Text(title)
                    .foregroundStyle(.textBlancoNegro)
            }
        }
        
    }
}


#Preview {
    PlusView()
}
