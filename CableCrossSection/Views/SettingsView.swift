//
//  SettingsView.swift
//  CableCrossSection
//
//  Created by Ahmed Halilovic on 21. 12. 2024..
//

import SwiftUI

struct SettingsView: View {
    @AppStorage("selectedLanguage") private var selectedLanguage: String = "en"
    
    @State private var showCompensationSheet = false
    @State private var showAppVersion = false
    @State private var showAboutMePopup = false
    
    var body: some View {
        Form {
            Section {
                VStack {
                    Picker(Bundle.localizedString(key: "language"), selection: $selectedLanguage) {
                        Text("English").tag("en")
                        Text("Bosanski").tag("bs-BA")
                    }
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
            
            Section {
                Button {
                    showCompensationSheet = true
                } label: {
                    Text(Bundle.localizedString(key: "compensation_button_text"))
                }
                .sheet(isPresented: $showCompensationSheet) { // Display sheet when button is pressed
                    CompensationCalcuatorView()
                }
                .buttonStyle(PlainButtonStyle())
                

            } header: {
                Text(Bundle.localizedString(key: "more_helpers"))
            }
            
            Section {
                Button {
                    showAppVersion = true
                } label: {
                    Text(Bundle.localizedString(key: "app_version"))
                }
                .foregroundColor(.black)
                .alert(Bundle.localizedString(key: "app_version"), isPresented: $showAppVersion) {
                    Button("OK", role: .cancel) { }
                } message: {
                    Text(Bundle.localizedString(key: "app_version_message"))
                }
                
                
                Button {
                    showAboutMePopup = true
                } label: {
                    Text(Bundle.localizedString(key: "about_info"))
                }
                .foregroundColor(.black)
                .alert(Bundle.localizedString(key: "about_info"), isPresented: $showAboutMePopup) {
                    Button("OK", role: .cancel) { }
                } message: {
                    Text(Bundle.localizedString(key: "about_info_message"))
                }
                
            } header: {
                Text("Info")
            }
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
