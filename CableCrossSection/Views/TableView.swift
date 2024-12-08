//
//  CableLoadTableView.swift
//  CableCrossSection
//
//  Created by Ahmed Halilovic on 12. 11. 2024..
//

import SwiftUI

struct TableView: View {
    @EnvironmentObject var sharedData: SharedDataModel
    
    let CableData = CableLoadData.cableData
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Header Row
            HStack {
                Text("Cross-Section mm2")
                    .bold()
                    .frame(maxWidth: .infinity, alignment: .leading)
                Text("Max Current (Cu)")
                    .bold()
                    .frame(maxWidth: .infinity, alignment: .center)
                Text("Fuse (Cu)")
                    .bold()
                    .frame(maxWidth: .infinity, alignment: .center)
                Text("Max Current (Al)")
                    .bold()
                    .frame(maxWidth: .infinity, alignment: .center)
                Text("Fuse (Al)")
                    .bold()
                    .frame(maxWidth: .infinity, alignment: .trailing)
            }
            .padding()
            .background(Color.gray.opacity(0.2))
            .font(.footnote)
            
            // Data Rows
            ForEach(CableData, id: \.id) { row in
                HStack {
                    Text(row.crossSection)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Text(row.maxCurrentCu)
                        .frame(maxWidth: .infinity, alignment: .center)
                    Text(row.fuseForCu)
                        .frame(maxWidth: .infinity, alignment: .center)
                    Text(row.maxCurrentAl.isEmpty ? "-" : row.maxCurrentAl)
                        .frame(maxWidth: .infinity, alignment: .center)
                    Text(row.fuseForAl.isEmpty ? "-" : row.fuseForAl)
                        .frame(maxWidth: .infinity, alignment: .trailing)
                }
                .padding(.vertical, 0.5)
                //.background(Color.white)
                //                .background(sharedData.selectedCopperRow == row ? Color.yellow.opacity(0.3) : Color.clear)
                //                .background(sharedData.selectedAlluminumRow == row ? Color.green.opacity(0.3) : Color.clear)
                .background(
                    sharedData.selectedCopperRow == row ? Color(red: 0.72, green: 0.45, blue: 0.20, opacity: 0.5) : // Copper-like color
                    sharedData.selectedAluminumRow == row ? Color(red: 0.75, green: 0.75, blue: 0.75, opacity: 0.5) : // Aluminum-like color
                    Color.clear
                )
            }
        }
        .padding()
        .border(Color.gray, width: 1) // Add border around the table
        
        
        
//        VStack {
//                HStack {
//                    Text("Cross-Section (mm2)")
//                        .bold()
//                        .background(Color.gray.opacity(0.2))
//                        .font(.subheadline)
//                        .frame(maxWidth: .infinity, alignment: .leading)
//                    Text("Max Current (Cu)")
//                        .bold()
//                        .font(.subheadline)
//                        .frame(maxWidth: .infinity, alignment: .center)
//                    Text("Fuse (Cu)").bold()
//                        .bold()
//                        .font(.subheadline)
//                        .frame(maxWidth: .infinity, alignment: .center)
//                    Text("Max Current (Al)")
//                        .bold()
//                        .font(.subheadline)
//                        .frame(maxWidth: .infinity, alignment: .trailing)
//                    Text("Fuse (Al)")
//                        .bold()
//                        .font(.subheadline)
//                        .frame(maxWidth: .infinity, alignment: .trailing)
//                }
//                .padding()
//
//                Divider() // Optional separator line
//
//                List(cableData) { cable in
//                    HStack {
//                        Text(cable.crossSection)
//                            .bold()
//                            .frame(maxWidth: .infinity, alignment: .leading)
//                            .padding(5)
//                        Divider().frame(width: 1, height: 20).background(Color.gray)
//                        Text(cable.maxCurrentCu).frame(maxWidth: .infinity, alignment: .leading)
//                        Text(cable.fuseForCu).frame(maxWidth: .infinity, alignment: .center)
//                        Text(cable.maxCurrentAl).frame(maxWidth: .infinity, alignment: .trailing)
//                        Text(cable.fuseForAl).frame(maxWidth: .infinity, alignment: .trailing)
//                    }
//                }
//        }
//        .padding()
    }
}

struct TableView_Previews: PreviewProvider {
    static var previews: some View {
        TableView()
    }
}
