//
//  ContentView.swift
//  CableCrossSection
//
//  Created by Ahmed Halilovic on 12. 11. 2024..
//

import SwiftUI

struct ContentView: View {
    @StateObject private var sharedData = SharedDataModel()
    
    var body: some View {
        TabView {
            NavigationStack {
                    CrossSectionView()
                    .environmentObject(sharedData)
                    .navigationTitle(Bundle.localizedString(key: "navigation_title_cross_section", comment: "Title for cross-section tab"))
                }
                .tabItem {
                    Label(Bundle.localizedString(key: "tab_label_cross_section"), systemImage: "circle.grid.cross.up.filled")
                }

                NavigationStack {
                    TableView()
                        .environmentObject(sharedData)
                        //.navigationTitle(Bundle.localizedString(key: "navigation_title_cable_load"))
                }
                .tabItem {
                    Label(Bundle.localizedString(key: "tab_label_table"), systemImage: "tablecells")
                }

                NavigationStack {
                    VoltageDropView()
                        .environmentObject(sharedData)
                        .navigationTitle(Bundle.localizedString(key: "navigation_title_voltage_drop"))
                }
                .tabItem {
                    Label(Bundle.localizedString(key: "tab_label_voltage_drop"), systemImage: "bolt.slash.fill")
                }
            
            NavigationStack {
                SettingsView()
                    .navigationTitle(Bundle.localizedString(key: "navigation_title_settings"))
            }
            .tabItem {
                Label(Bundle.localizedString(key: "tab_label_settings"), systemImage: "gear")
            }
        
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
