//
//  ContentView.swift
//  CableCrossSection
//
//  Created by Ahmed Halilovic on 12. 11. 2024..
//

import SwiftUI

struct ContentView: View {
    @StateObject private var sharedData = SharedDataModel()
    @AppStorage("selectedTab") private var selectedTab = 0

    var body: some View {
        TabView(selection: $selectedTab) {
            NavigationStack {
                CrossSectionView()
                    .environmentObject(sharedData)
                    .navigationTitle("Cross-section")
            }
            .tabItem {
                Label("Cross Section", systemImage: "circle.grid.cross.up.filled")
            }
            .tag(0)

            NavigationStack {
                TableView()
                    .environmentObject(sharedData)
            }
            .tabItem {
                Label("Table", systemImage: "tablecells")
            }
            .tag(1)

            NavigationStack {
                VoltageDropView()
                    .environmentObject(sharedData)
                    .navigationTitle("Voltage Drop")
            }
            .tabItem {
                Label("Voltage Drop", systemImage: "bolt.slash.fill")
            }
            .tag(2)

            NavigationStack {
                SettingsView()
                    .navigationTitle("Settings")
            }
            .tabItem {
                Label("Settings", systemImage: "gear")
            }
            .tag(3)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
