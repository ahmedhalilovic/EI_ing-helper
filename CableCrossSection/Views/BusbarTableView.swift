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
            Text("Busbar table")
                .font(.title3)
                .foregroundColor(.primary)
                .bold()
                .padding(.top, 12)
                .padding(.bottom, 10)
            
            // Table Header
            HStack {
                Text("Size in mm")
                    .bold()
                    .frame(maxWidth: .infinity)
                Text("Stacked")
                    .bold()
                    .frame(maxWidth: .infinity)
                Text("Max current (A)")
                    .bold()
                    .frame(maxWidth: .infinity)
                    .multilineTextAlignment(.center)
            }
            .font(.subheadline)
            .bold()
            .foregroundColor(.primary)
            
            // Data Rows
            ForEach(busbarData, id: \.id) { row in
                HStack {
                    Text(row.size).frame(maxWidth: .infinity)
                    Text(row.stacked).frame(maxWidth: .infinity)
                    Text(row.maxCurrentForBusbar).frame(maxWidth: .infinity)
                }
                .padding(.vertical, 5)
                .foregroundColor(.primary)
                .background(
                    sharedData.selectedBusbarRow == row ? Color(red: 0.72, green: 0.45, blue: 0.20, opacity: 0.75) :
                    Color(.systemBackground)
                )
                .cornerRadius(5)
                .shadow(radius: 1)
            }
            Spacer()
            HStack {
                Button(action: { sharedData.showBusbarSheet = false }) {
                    Text("Close")
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .frame(width: 120)
                        .padding(.vertical, 10)
                        .background(Color.red)
                        .cornerRadius(10)
                }
                .buttonStyle(PlainButtonStyle())
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 12)
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.regularMaterial)
        
    }
}

struct BusbarTableView_Previews: PreviewProvider {
    static var previews: some View {
        let model = SharedDataModel()
        return BusbarTableView()
            .environmentObject(model)
    }
}
