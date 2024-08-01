//
//  KeyboardManager.swift
//  MyReads
//
//  Created by Axel Álvarez Santos on 27/7/24.
//

import SwiftUI
import Combine

@MainActor
class KeyboardManager: ObservableObject {
    @Published var isKeyboardVisible = false
    private var cancellableSet: Set<AnyCancellable> = []
    
    init() {
        NotificationCenter.default.publisher(for: UIResponder.keyboardWillShowNotification)
            .sink { _ in
                self.isKeyboardVisible = true
            }
            .store(in: &cancellableSet)
        
        NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification)
            .sink { _ in
                self.isKeyboardVisible = false
            }
            .store(in: &cancellableSet)
    }
}

extension UIApplication {
    func hideKeyboard() {
        self.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}


