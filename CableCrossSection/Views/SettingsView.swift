//
//  SettingsView.swift
//  CableCrossSection
//
//  Created by Ahmed Halilovic on 21. 12. 2024..
//

import SwiftUI

struct SettingsView: View {
    @AppStorage("selectedLanguage") private var selectedLanguage: String = "en"
    
    var body: some View {
        Form {
            Section {
                Picker(Bundle.localizedString(key: "language"), selection: $selectedLanguage) {
                    Text("English").tag("en")
                    Text("Bosanski").tag("bs-BA")
                }
            } header: {
                Text(Bundle.localizedString(key: "language_selection"))
            }
            .onAppear {
                Bundle.setLanguage(selectedLanguage)
            }
            .onChange(of: selectedLanguage) { newValue in
                Bundle.setLanguage(newValue)
            }

        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
