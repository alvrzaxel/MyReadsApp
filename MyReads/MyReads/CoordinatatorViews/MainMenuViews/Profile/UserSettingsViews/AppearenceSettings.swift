//
//  AppearenceSettings.swift
//  MyReads
//
//  Created by Axel Álvarez Santos on 29/7/24.
//

import SwiftUI

enum AppearenceMode2: String, CaseIterable {
    case light
    case dark
    case system
}


struct UserSettingsAppearance: View {
    @AppStorage("appearanceMode") private var appearanceMode: String = AppearenceMode2.system.rawValue
        
        var body: some View {
            DLMode2(appearanceMode: $appearanceMode)
        }
}

#Preview {
    UserSettingsAppearance()
}


struct DLMode2: View {
    @Binding var appearanceMode: String
    @Environment(\.colorScheme) var currentColorScheme

    var body: some View {
        ZStack {
            Color.gray.opacity(0.3)
            VStack {
                Spacer()
                ZStack {
                    RoundedRectangle(cornerRadius: 30)
                        .frame(height: 270)
                        .foregroundStyle(.backgroundGeneral)
                    VStack(spacing: 20) {
                        HStack {
                            Text("Appearance")
                            Spacer()
                            Image(systemName: "xmark.circle.fill")
                        }
                        .bold()
                        .font(.title)
                        .foregroundStyle(.primary)
                        .padding(.horizontal)
                        Divider().padding(.horizontal, 30)
                        HStack(spacing: 40) {
                            Button(action: {
                                appearanceMode = AppearenceMode2.light.rawValue
                                print(appearanceMode)
                            }, label: {
                                UIButton2(mode: .light, currentMode: $appearanceMode, Rbg: .customGray3, Rbgi: .customGray1, ibg: .customGray2)
                            })
                            .tint(.primary)
                            
                            Button(action: {
                                appearanceMode = AppearenceMode2.dark.rawValue
                                print(appearanceMode)
                            }, label: {
                                UIButton2(mode: .dark, currentMode: $appearanceMode, Rbg: .customGray5, Rbgi: .customGray3, ibg: .customGray4)
                            })
                            .tint(.primary)
                            
                            Button(action: {
                                appearanceMode = AppearenceMode2.system.rawValue
                                print(appearanceMode)
                            }, label: {
                                UIButton2(mode: .system, currentMode: $appearanceMode, Rbg: .customGray3, Rbgi: .customGray1, ibg: .white)
                            })
                            .tint(.primary)
                        }
                    }
                }
                .padding(.horizontal, 8)
                .preferredColorScheme(colorScheme(for: appearanceMode))
            }
            .offset(y: -30)
        }
        
    }
    private func colorScheme(for mode: String) -> ColorScheme? {
            switch AppearenceMode2(rawValue: mode) {
            case .light:
                return .light
            case .dark:
                return .dark
            case .system:
                return nil // Esto permite que el esquema del sistema se use
            case .none:
                return nil
            }
        }
}

struct UIButton2: View {
    var mode: AppearenceMode2
    @Binding var currentMode: String
    var Rbg: Color = .gray
    var Rbgi: Color = .yellow
    var ibg: Color = .blue
    
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
                if currentMode == mode.rawValue {
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(lineWidth: 2)
                        .padding(-3)
                }
            }
            .background(Rbg, in: RoundedRectangle(cornerRadius: 7))
            Text(String(describing: mode).capitalized).foregroundStyle(currentMode == mode.rawValue ? .yellow : .blue)
                .font(.system(size: 15))
                .frame(width: 80, height: 25)
                .background(currentMode == mode.rawValue ? .blue : .yellow, in: RoundedRectangle(cornerRadius: 10))
            
        }
        .scaleEffect(currentMode == mode.rawValue ? 1.1 : 0.9)
        .animation(.default, value: currentMode)
    }
}
