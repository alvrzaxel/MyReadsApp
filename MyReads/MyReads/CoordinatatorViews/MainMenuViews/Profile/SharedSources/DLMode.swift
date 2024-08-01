//
//  DLMode.swift
//  MyReads
//
//  Created by Axel Álvarez Santos on 27/7/24.
//

import SwiftUI

struct ContetView:View {
    @State private var appearence: AppearenceMode = .dark
    @State private var colorScheme: ColorScheme? = nil
    @State var show = true
    
    var body: some View {
        ZStack {
            Color.backgroundGeneral.ignoresSafeArea()
            VStack {
                Text("Hello")
                    .foregroundStyle(.primary)
                Button(action: {
                    withAnimation {
                        show.toggle()
                    }
                }, label: {
                    Text("Appearance").bold().font(.title2)
                        .frame(minWidth: 200, minHeight: 60)
                        .background(.gray, in: RoundedRectangle(cornerRadius: 20))
                })
            }
            
            DLMode(appearanceMode: $appearence, colorScheme: $colorScheme, show: $show)
                .ignoresSafeArea()
        }
    }
}

#Preview {
    ContetView()
}


struct DLMode: View {
    @Binding var appearanceMode: AppearenceMode
    @Binding var colorScheme: ColorScheme?
    @Binding var show: Bool
    var body: some View {
        ZStack {
            Color(show ? .clear : .gray.opacity(0.3))
            VStack {
                Spacer()
                ZStack {
                    RoundedRectangle(cornerRadius: 30)
                        .frame(height: 270).foregroundStyle(.backgroundGeneral)
                    VStack(spacing: 20) {
                        HStack {
                            Text("Appearence")
                            Spacer()
                            Image(systemName: "xmark.circle.fill")
                        }
                        .bold().font(.title).foregroundStyle(.primary)
                        .padding(.horizontal)
                        Divider().padding(.horizontal, 30)
                        HStack(spacing: 40) {
                            
                            Button(action: {
                                appearanceMode = .light
                                colorScheme = .light
                            }, label: {
                                UIButton(mode: .light, currentMode: $appearanceMode, Rbg: .customGray3, Rbgi: .customGray1, ibg: .customGray2)
                            })
                            .tint(.primary)
                            
                            Button(action: {
                                appearanceMode = .dark
                                colorScheme = .dark
                            }, label: {
                                UIButton(mode: .dark, currentMode: $appearanceMode, Rbg: .customGray5, Rbgi: .customGray3, ibg: .customGray4)
                            })
                            .tint(.primary)
                            
                            
                            Button(action: {
                                appearanceMode = .system
                                colorScheme = nil
                            }, label: {
                                ZStack {
                                    UIButton(mode: .system, currentMode: $appearanceMode, Rbg: .customGray3, Rbgi: .customGray1, ibg: .white)
                                    UIButton(mode: .system, currentMode: $appearanceMode, Rbg: .customGray3, Rbgi: .customGray1, ibg: .black)
                                        .mask {
                                            RoundedRectangle(cornerRadius: 10)
                                                .frame(width: 50, height: 200)
                                                .offset(x: -24)
                                        }
                                }
                                
                            })
                            
                            
                        }
                        
                    }
                }
                .padding(.horizontal, 8)
                .preferredColorScheme(colorScheme)
            }
            .offset(y: show ? 300 : -30)
        }
        .onTapGesture {
            withAnimation {
                show.toggle()
            }
        }
    }
}

#Preview {
    DLMode(appearanceMode: .constant(.dark), colorScheme: .constant(.light), show: .constant(false))
}

enum AppearenceMode {
    case dark, light, system
}

struct UIButton: View {
    var mode: AppearenceMode
    @Binding var currentMode: AppearenceMode
    var Rbg: Color
    var Rbgi: Color
    var ibg: Color
    
    var body: some View {
        VStack(spacing: 20) {
            VStack {
                Circle().frame(width: 20, height: 20)
                RoundedRectangle(cornerRadius: 10)
                    .frame(width: 49, height: 6)
                VStack(spacing: 5) {
                    RoundedRectangle(cornerRadius: 10)
                        .frame(width: 38, height: 6)
                    RoundedRectangle(cornerRadius: 10)
                        .frame(width: 38, height: 6)
                    RoundedRectangle(cornerRadius: 10)
                        .frame(width: 38, height: 6)
                }
                .frame(width: 55, height: 50)
                .background(ibg, in: RoundedRectangle(cornerRadius: 5))
            }
            .foregroundStyle(Rbgi)
            .padding(8)
            .overlay {
                if currentMode == mode {
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(lineWidth: 2)
                        .padding(-3)
                }
            }
            .background(Rbg, in: RoundedRectangle(cornerRadius: 7))
            Text(String(describing: mode).capitalized).foregroundStyle(currentMode == mode ? .yellow : .blue)
                .font(.system(size: 15))
                .frame(width: 80, height: 25)
                .background(currentMode == mode ? .blue : .yellow, in: RoundedRectangle(cornerRadius: 10))
            
        }
        .scaleEffect(currentMode == mode ? 1.1 : 0.9)
        .animation(.default, value: currentMode)
    }
}
