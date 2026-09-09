//
//  SettingsView.swift
//  CableCrossSection
//
//  Created by Ahmed Halilovic on 21. 12. 2024..
//

import SwiftUI

struct SettingsView: View {
    @AppStorage("appLanguage") private var appLanguage = "en"

    @State private var showCompensationSheet = false
    @State private var showAppVersion = false
    @State private var showAboutMePopup = false

    var body: some View {
        Form {
            Section {
                Picker("Language", selection: $appLanguage) {
                    Text("English").tag("en")
                    Text("Bosanski").tag("bs")
                }
            } header: {
                Text("Choose language")
            }

            Section {
                Button {
                    showCompensationSheet = true
                } label: {
                    Text("COMPENSATION CALCULATOR")
                }
                .sheet(isPresented: $showCompensationSheet) {
                    CompensationCalcuatorView()
                }
                .buttonStyle(PlainButtonStyle())
            } header: {
                Text("More helpers")
            }

            Section {
                Button {
                    showAppVersion = true
                } label: {
                    Text("App version")
                }
                .alert("App version", isPresented: $showAppVersion) {
                    Button("OK", role: .cancel) { }
                } message: {
                    Text("App v1.0")
                }

                Button {
                    showAboutMePopup = true
                } label: {
                    Text("About app")
                }
                .alert("About app", isPresented: $showAboutMePopup) {
                    Button("OK", role: .cancel) { }
                } message: {
                    Text("This app helps you calculate cable cross-sections, voltage drops, and other electrical parameters.")
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
