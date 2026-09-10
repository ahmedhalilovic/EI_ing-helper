//
//  TableView.swift
//  Tables
//
//  Created by Ahmed Halilovic on 12. 11. 2024..
//

import SwiftUI

struct TableView: View {
    @EnvironmentObject var sharedData: SharedDataModel
    @State private var selectedTable = 0

    var body: some View {
        ScrollView {
            VStack {
                Picker("Select Table", selection: $selectedTable) {
                    Text("Cable Load").tag(0)
                    Text("Busbar").tag(1)
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()

                VStack {
                    if selectedTable == 0 {
                        CableLoadView()
                    } else {
                        BusbarView()
                    }
                }
            }
        }
        .navigationTitle("Tables")
        .navigationBarTitleDisplayMode(.large)
    }
}

// Cable Load Table
struct CableLoadView: View {
    @EnvironmentObject var sharedData: SharedDataModel

    let CableData = CableLoadData.cableData

    var body: some View {
        VStack {
            Text("Cable Load Table")
                .font(.headline)
                .padding(.bottom, 10)

            // Table headers
            HStack {
                Text("Cross-Section mm2")
                    .frame(maxWidth: .infinity)
                Text("Max Current (Cu)")
                    .frame(maxWidth: .infinity)
                Text("Fuse (Cu)")
                    .frame(maxWidth: .infinity)
                Text("Max Current (Al)")
                    .frame(maxWidth: .infinity)
                Text("Fuse (Al)")
                    .frame(maxWidth: .infinity)
            }
            .font(.subheadline)
            .bold()
            .background(Color.gray.opacity(0.2))
            ForEach(CableData, id: \.id) { row in
                let isCopperRow = sharedData.selectedCopperRow
                let isAluminumRow = sharedData.selectedAluminumRow

                HStack {
                    Text(row.crossSection)
                        .frame(maxWidth: .infinity)
                        .padding(5)
                        .bold()
                        .background(
                            isCopperRow == row ? Color(red: 0.72, green: 0.45, blue: 0.20, opacity: 0.5) :
                            isAluminumRow == row ? Color(red: 0.65, green: 0.65, blue: 0.65, opacity: 0.7) :
                            Color.clear
                        )
                    Text(row.maxCurrentCu)
                        .frame(maxWidth: .infinity)
                        .padding(5)
                        .background(
                            isCopperRow == row ? Color(red: 0.72, green: 0.45, blue: 0.20, opacity: 0.5) :
                            Color.clear
                        )
                    Text(row.fuseForCu)
                        .frame(maxWidth: .infinity)
                        .padding(5)
                        .background(
                            isCopperRow == row ? Color(red: 0.72, green: 0.45, blue: 0.20, opacity: 0.5) :
                            Color.clear
                        )
                    Text(row.maxCurrentAl.isEmpty ? "-" : row.maxCurrentAl)
                        .frame(maxWidth: .infinity)
                        .padding(5)
                        .background(
                            isAluminumRow == row ? Color(red: 0.65, green: 0.65, blue: 0.65, opacity: 0.7) :
                            Color.clear
                        )
                    Text(row.fuseForAl.isEmpty ? "-" : row.fuseForAl)
                        .frame(maxWidth: .infinity)
                        .padding(5)
                        .background(
                            isAluminumRow == row ? Color(red: 0.65, green: 0.65, blue: 0.65, opacity: 0.7) :
                            Color.clear
                        )
                }
                .background(Color.gray.opacity(0.1))
                .cornerRadius(5)
            }
        }
    }
}

// Busbar Table
struct BusbarView: View {
    @EnvironmentObject var sharedData: SharedDataModel

    let BusbarData = BusbarLoadData.busbarData

    var body: some View {
        VStack {
            Text("Busbar table")
                .font(.headline)
                .padding(.bottom, 10)

            // Table headers
            HStack {
                Text("Size in mm")
                    .frame(maxWidth: .infinity)
                Text("Stacked")
                    .frame(maxWidth: .infinity)
                Text("Max current (A)")
                    .frame(maxWidth: .infinity)
            }
            .font(.subheadline)
            .bold()
            .background(Color.gray.opacity(0.2))

            ForEach(BusbarData, id: \.id) { row in
                HStack {
                    Text(row.size).frame(maxWidth: .infinity)
                    Text(row.stacked).frame(maxWidth: .infinity)
                    Text(row.maxCurrentForBusbar).frame(maxWidth: .infinity)
                }
                .padding(.vertical, 5)
                .background(Color.gray.opacity(0.2))
                .background(
                    sharedData.selectedBusbarRow == row ? Color(red: 0.72, green: 0.45, blue: 0.20, opacity: 0.5) :
                    Color.clear
                )
                .cornerRadius(5)
            }
        }
    }
}

struct TableView_Previews: PreviewProvider {
    static var previews: some View {
        TableView()
            .environmentObject(SharedDataModel())
    }
}
