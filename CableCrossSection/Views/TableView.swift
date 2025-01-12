//
//  TableView.swift
//  Tables
//
//  Created by Ahmed Halilovic on 12. 11. 2024..
//

import SwiftUI

struct TableView: View {
    @EnvironmentObject var sharedData: SharedDataModel
    @State private var selectedTable = Bundle.localizedString(key: "table_cable_name")
    
    let tables = [Bundle.localizedString(key: "table_cable_name"), Bundle.localizedString(key: "table_busbar_name")] // Picker options
    
    var body: some View {
            ScrollView {
                VStack {
                    Picker("Select Table", selection: $selectedTable) {
                        ForEach(tables, id: \.self) { table in
                            Text(table)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .padding()
                    
                    VStack {
                        if selectedTable == Bundle.localizedString(key: "table_cable_name") {
                            CableLoadView()
                        } else {
                            BusbarView()
                        }
                    }
                }
            }
            .navigationTitle(Bundle.localizedString(key: "tables")) // Main navigation title
            .navigationBarTitleDisplayMode(.large) // Large title enabled
    }
}

// Cable Load Table
struct CableLoadView: View {
    @EnvironmentObject var sharedData: SharedDataModel
    
    let CableData = CableLoadData.cableData
    
    var body: some View {
        VStack {
            Text(Bundle.localizedString(key: "table_title"))
                .font(.headline)
                .padding(.bottom, 10)
            
            // Table headers
            HStack {
                Text(Bundle.localizedString(key: "header_cross_section"))
                    .frame(maxWidth: .infinity)
                Text(Bundle.localizedString(key: "header_max_current_cu"))
                    .frame(maxWidth: .infinity)
                Text(Bundle.localizedString(key: "header_fuse_cu"))
                    .frame(maxWidth: .infinity)
                Text(Bundle.localizedString(key: "header_max_current_al"))
                    .frame(maxWidth: .infinity)
                Text(Bundle.localizedString(key: "header_fuse_al"))
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
                            isCopperRow == row ? Color(red: 0.72, green: 0.45, blue: 0.20, opacity: 0.5) : // Copper-like color
                            isAluminumRow == row ? Color(red: 0.65, green: 0.65, blue: 0.65, opacity: 0.7) : // Aluminum-like color
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
            Text(Bundle.localizedString(key: "recomended_busbar_sizes"))
                .font(.headline)
                .padding(.bottom, 10)
            
            // Table headers
            HStack {
                Text(Bundle.localizedString(key: "busbar_size_title"))
                    .frame(maxWidth: .infinity)
                Text(Bundle.localizedString(key: "stacked_title"))
                    .frame(maxWidth: .infinity)
                Text(Bundle.localizedString(key: "max_current_column_title"))
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
                    sharedData.selectedBusbarRow == row ? Color(red: 0.72, green: 0.45, blue: 0.20, opacity: 0.5) : // Busbar color
                    Color.clear
                )
                .cornerRadius(5)
            }
        }
    }
}
    
    
    //    var body: some View {
    //        VStack(alignment: .leading, spacing: 0) {
    //            // Header Row
    //            HStack {
    //                Text("Cross-Section mm2")
    //                    .bold()
    //                    .frame(maxWidth: .infinity, alignment: .leading)
    //                Text("Max Current (Cu)")
    //                    .bold()
    //                    .frame(maxWidth: .infinity, alignment: .center)
    //                    .padding(5) // Optional: Add padding to make it visually better
    //                    .background(Color(red: 0.72, green: 0.45, blue: 0.20, opacity: 0.5))
    //                    .cornerRadius(8) // Optional: Add rounded corners
    //                    .foregroundColor(.black) // Set text color for contrast
    //                Text("Fuse (Cu)")
    //                    .bold()
    //                    .frame(maxWidth: .infinity, alignment: .center)
    //                    .padding(5) // Optional: Add padding to make it visually better
    //                    .background(Color(red: 0.72, green: 0.45, blue: 0.20, opacity: 0.5))
    //                    .cornerRadius(4) // Optional: Add rounded corners
    //                    .foregroundColor(.black) // Set text color for contrast
    //                Text("Max Current (Al)")
    //                    .bold()
    //                    .frame(maxWidth: .infinity, alignment: .center)
    //                    .padding(5) // Optional: Add padding to make it visually better
    //                    .background(Color(red: 0.75, green: 0.75, blue: 0.75, opacity: 0.5))
    //                    .cornerRadius(8) // Optional: Add rounded corners
    //                    .foregroundColor(.black) // Set text color for contrast
    //                Text("Fuse (Al)")
    //                    .bold()
    //                    .frame(maxWidth: .infinity, alignment: .trailing)
    //                    .padding(5) // Optional: Add padding to make it visually better
    //                    .background(Color(red: 0.75, green: 0.75, blue: 0.75, opacity: 0.5))
    //                    .cornerRadius(4) // Optional: Add rounded corners
    //                    .foregroundColor(.black) // Set text color for contrast
    //            }
    //            .padding()
    //            .background(Color.gray.opacity(0.2))
    //            .font(.footnote)
    //
    //            // Data Rows
    //            ForEach(CableData, id: \.id) { row in
    //                HStack {
    //                    Text(row.crossSection)
    //                        .frame(maxWidth: .infinity, alignment: .leading)
    //                    Text(row.maxCurrentCu)
    //                        .frame(maxWidth: .infinity, alignment: .center)
    //                    Text(row.fuseForCu)
    //                        .frame(maxWidth: .infinity, alignment: .center)
    //                    Text(row.maxCurrentAl.isEmpty ? "-" : row.maxCurrentAl)
    //                        .frame(maxWidth: .infinity, alignment: .center)
    //                    Text(row.fuseForAl.isEmpty ? "-" : row.fuseForAl)
    //                        .frame(maxWidth: .infinity, alignment: .trailing)
    //                }
    //                .padding(.vertical, 0.5)
    //                .background(
    //                    sharedData.selectedCopperRow == row ? Color(red: 0.72, green: 0.45, blue: 0.20, opacity: 0.5) : // Copper-like color
    //                    sharedData.selectedAluminumRow == row ? Color(red: 0.75, green: 0.75, blue: 0.75, opacity: 0.5) : // Aluminum-like color
    //                    Color.clear
    //                )
    //            }
    //        }
    //        .padding()
    //        .border(Color.gray, width: 1) // Add border around the table
    //
    //        HStack {
    //
    //            // Legend
    //            VStack {
    //                // Copper Legend
    //                HStack(spacing: 5) {
    //                    RoundedRectangle(cornerRadius: 4)
    //                        .fill(Color(red: 0.72, green: 0.45, blue: 0.20, opacity: 0.5)) // Copper color
    //                        .frame(width: 20, height: 20)
    //                    Text("Copper")
    //                        .font(.caption)
    //                }
    //                .frame(maxWidth: .infinity, alignment: .leading)
    //
    //                // Aluminum Legend
    //                HStack(spacing: 5) {
    //                    RoundedRectangle(cornerRadius: 4)
    //                        .fill(Color(red: 0.75, green: 0.75, blue: 0.75, opacity: 0.5)) // Aluminum color
    //                        .frame(width: 20, height: 20)
    //                    Text("Aluminum")
    //                        .font(.caption)
    //                }
    //                .frame(maxWidth: .infinity, alignment: .leading)
    //            }
    //            .padding(.horizontal)
    //            .padding(.top, 8)
    //            .frame(maxWidth: .infinity, alignment: .leading)
    //
    //            Spacer()
    //
    //            Button(action: {
    //                sharedData.showBusbarSheet = true // Show the sheet when the button is pressed
    //            }) {
    //                Text("SHOW BUSBAR\nCURRENTS")
    //                    .font(.subheadline) // Smaller font size
    //                    .foregroundColor(.white)
    //                    .multilineTextAlignment(.center)
    //                    .padding(.vertical, 10) // Reduced vertical padding
    //                    .padding(.horizontal, 20) // Reduced horizontal padding
    //                    .cornerRadius(10) // Smaller corner radius
    //                    .shadow(radius: 5) // Reduced shadow radius
    //                    .padding(.horizontal, 15)
    //                    .background(Color(red: 0.72, green: 0.45, blue: 0.20, opacity: 0.5))
    //            }
    //        }
    //
    //    }
//}

struct TableView_Previews: PreviewProvider {
    static var previews: some View {
        TableView()
    }
}
