//
//  KeyboardToolbarModifier.swift
//  CableCrossSection
//
//  Created by Ahmed Halilovic on 17. 11. 2024..
//

import SwiftUI

struct KeyboardToolbar: ViewModifier {
    func body(content: Content) -> some View {
        content
            .toolbar {
                ToolbarItemGroup(placement: .keyboard) {
                    Spacer()
                    Button("Done") {
                        // Dismiss the keyboard
                        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                    }
                }
            }
    }
}

extension View {
    func keyboardToolbar() -> some View {
        self.modifier(KeyboardToolbar())
    }
}

