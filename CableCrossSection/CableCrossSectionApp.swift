//
//  CableCrossSectionApp.swift
//  CableCrossSection
//
//  Created by Ahmed Halilovic on 12. 11. 2024..
//

import SwiftUI

@main
struct CableCrossSectionApp: App {
    @AppStorage("appLanguage") var appLanguage = "en"

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.locale, Locale(identifier: appLanguage))
                .id(appLanguage)
        }
    }
}
