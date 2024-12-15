//
//  BusbarTableView.swift
//  CableCrossSection
//
//  Created by Ahmed Halilovic on 15. 12. 2024..
//

import SwiftUI

struct BusbarTableView: View {
    @EnvironmentObject var sharedData: SharedDataModel
    
    let busbarData = BusbarLoadData.busbarData
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Recommended Copper Busbar Sizes")
                .font(.title3)
                .bold()
                .padding(.bottom, 10)
            
            // Table Header
            HStack {
                Text("WxH (mm²)")
                    .bold()
                    .frame(maxWidth: .infinity, alignment: .leading)
                Text("Max current (A)")
                    .bold()
                    .frame(maxWidth: .infinity, alignment: .center)
            }
            .padding()
            .background(Color.gray.opacity(0.2))
            .cornerRadius(10)
            
            // Data Rows
            ForEach(busbarData) { row in
                HStack {
                    Text(row.size)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Text(row.maxCurrentForBusbar)
                        .frame(maxWidth: .infinity, alignment: .center)
                }
                .padding(.vertical, 5)
                .background(Color.white)
                .cornerRadius(5)
                .shadow(radius: 1)
            }
            Spacer()
            HStack {
                Button(action: { sharedData.showBusbarSheet = false }) {
                    Text("Close")
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.red)
                        .cornerRadius(8)
                }
            }
            .frame(maxWidth: .infinity)
            .padding()
        }
        .padding()
        .background(
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(red: 0.72, green: 0.45, blue: 0.20), // Copper color
                    Color(red: 0.52, green: 0.35, blue: 0.15) // Darker copper
                ]),
                startPoint: .top,
                endPoint: .bottom
            )
        )
        .cornerRadius(15)
        
    }
}

struct BusbarTableView_Previews: PreviewProvider {
    static var previews: some View {
        BusbarTableView()
    }
}
