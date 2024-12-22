//
//  BundleLanguage.swift
//  CableCrossSection
//
//  Created by Ahmed Halilovic on 21. 12. 2024..
//

import Foundation

extension Bundle {
    private static var bundle: Bundle?

    /// Sets the app's language dynamically by loading the appropriate `.lproj` bundle.
    static func setLanguage(_ language: String) {
        guard let path = Bundle.main.path(forResource: language, ofType: "lproj") else {
            bundle = Bundle.main // Fallback to the main bundle if the language file is not found
            return
        }
        bundle = Bundle(path: path)
    }

    /// Returns a localized string from the dynamically set language bundle.
    static func localizedString(key: String, comment: String = "") -> String {
        return bundle?.localizedString(forKey: key, value: nil, table: nil) ?? NSLocalizedString(key, comment: comment)
    }
}

