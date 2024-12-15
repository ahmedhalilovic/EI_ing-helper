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
                        .navigationTitle("Cross-section")
                }
                .tabItem {
                    Label("Cross Section", systemImage: "circle.grid.cross.up.filled")
                }

                NavigationStack {
                    TableView()
                        .environmentObject(sharedData)
                        .navigationTitle("Cable load")
                }
                .tabItem {
                    Label("Table", systemImage: "tablecells")
                }

                NavigationStack {
                    VoltageDropView()
                        .environmentObject(sharedData)
                        .navigationTitle("Voltage Drop")
                }
                .tabItem {
                    Label("Voltage Drop", systemImage: "bolt.slash.fill")
                }
        
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
