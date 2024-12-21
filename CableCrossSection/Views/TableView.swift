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
                    .padding(5) // Optional: Add padding to make it visually better
                    .background(Color(red: 0.72, green: 0.45, blue: 0.20, opacity: 0.5))
                    .cornerRadius(8) // Optional: Add rounded corners
                    .foregroundColor(.black) // Set text color for contrast
                Text("Fuse (Cu)")
                    .bold()
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(5) // Optional: Add padding to make it visually better
                    .background(Color(red: 0.72, green: 0.45, blue: 0.20, opacity: 0.5))
                    .cornerRadius(4) // Optional: Add rounded corners
                    .foregroundColor(.black) // Set text color for contrast
                Text("Max Current (Al)")
                    .bold()
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(5) // Optional: Add padding to make it visually better
                    .background(Color(red: 0.75, green: 0.75, blue: 0.75, opacity: 0.5))
                    .cornerRadius(8) // Optional: Add rounded corners
                    .foregroundColor(.black) // Set text color for contrast
                Text("Fuse (Al)")
                    .bold()
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    .padding(5) // Optional: Add padding to make it visually better
                    .background(Color(red: 0.75, green: 0.75, blue: 0.75, opacity: 0.5))
                    .cornerRadius(4) // Optional: Add rounded corners
                    .foregroundColor(.black) // Set text color for contrast
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
                .background(
                    sharedData.selectedCopperRow == row ? Color(red: 0.72, green: 0.45, blue: 0.20, opacity: 0.5) : // Copper-like color
                    sharedData.selectedAluminumRow == row ? Color(red: 0.75, green: 0.75, blue: 0.75, opacity: 0.5) : // Aluminum-like color
                    Color.clear
                )
            }
        }
        .padding()
        .border(Color.gray, width: 1) // Add border around the table
        
        HStack {
            
            // Legend
            VStack {
                // Copper Legend
                HStack(spacing: 5) {
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color(red: 0.72, green: 0.45, blue: 0.20, opacity: 0.5)) // Copper color
                        .frame(width: 20, height: 20)
                    Text("Copper")
                        .font(.caption)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                
                // Aluminum Legend
                HStack(spacing: 5) {
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color(red: 0.75, green: 0.75, blue: 0.75, opacity: 0.5)) // Aluminum color
                        .frame(width: 20, height: 20)
                    Text("Aluminum")
                        .font(.caption)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(.horizontal)
            .padding(.top, 8)
            .frame(maxWidth: .infinity, alignment: .leading)
            
            Spacer()
            
            Button(action: {
                sharedData.showBusbarSheet = true // Show the sheet when the button is pressed
            }) {
                Text("SHOW BUSBAR\nCURRENTS")
                    .font(.subheadline) // Smaller font size
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .padding(.vertical, 10) // Reduced vertical padding
                    .padding(.horizontal, 20) // Reduced horizontal padding
                    .cornerRadius(10) // Smaller corner radius
                    .shadow(radius: 5) // Reduced shadow radius
                    .padding(.horizontal, 15)
                    .background(Color(red: 0.72, green: 0.45, blue: 0.20, opacity: 0.5))
            }
        }
        
    }
}

struct TableView_Previews: PreviewProvider {
    static var previews: some View {
        TableView()
    }
}
