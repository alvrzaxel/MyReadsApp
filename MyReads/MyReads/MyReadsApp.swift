//
//  MyReadsApp.swift
//  MyReads
//
//  Created by Axel Álvarez Santos on 20/7/24.
//

import SwiftUI
import FirebaseCore
import GoogleSignIn

// AppDelegate para configurar Firebase y manejar la URL de redirección de Google Sign-In
class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        return true
    }
    
    // Maneja la URL de redirección de Google Sign-In
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        return GIDSignIn.sharedInstance.handle(url)
    }
}

@main
struct MyReadsApp: App {
    // Vincula el AppDelegate con SwiftUI
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    @AppStorage("appearanceMode") private var appearanceMode: String = AppearenceMode2.system.rawValue
    
    var body: some Scene {
        WindowGroup {
            CoordinatorView()
                .preferredColorScheme(currentColorScheme)
            
        }
    }
    
    var currentColorScheme: ColorScheme? {
            switch AppearenceMode2(rawValue: appearanceMode) ?? .system {
            case .light:
                return .light
            case .dark:
                return .dark
            case .system:
                return nil
            }
        }
}
