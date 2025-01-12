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
            Text(Bundle.localizedString(key: "recomended_busbar_sizes"))
                .font(.title3)
                
                .foregroundColor(.white)
                .bold()
                .padding(.bottom, 10)
            
            // Table Header
            HStack {
                Text(Bundle.localizedString(key: "busbar_size_title"))
                    .bold()
                    .frame(maxWidth: .infinity)
                Text(Bundle.localizedString(key: "stacked_title"))
                    .bold()
                    .frame(maxWidth: .infinity)
                Text(Bundle.localizedString(key: "max_current_column_title"))
                    .bold()
                    .frame(maxWidth: .infinity)
                    .multilineTextAlignment(.center)
            }
            .font(.subheadline)
            .bold()
            .foregroundColor(.white)
            .cornerRadius(10)
            
            // Data Rows
            ForEach(busbarData, id: \.id) { row in
                HStack {
                    Text(row.size).frame(maxWidth: .infinity)
                    Text(row.stacked).frame(maxWidth: .infinity)
                    Text(row.maxCurrentForBusbar).frame(maxWidth: .infinity)
                }
                .padding(.vertical, 5)
                .foregroundColor(.black)
                .background(
                    sharedData.selectedBusbarRow == row ? Color(red: 0.72, green: 0.45, blue: 0.20, opacity: 0.75) : // Busbar color
                    Color.clear
                )
                .background(Color.white)
                .cornerRadius(5)
                .shadow(radius: 1)
            }
            Spacer()
            HStack {
                Button(action: { sharedData.showBusbarSheet = false }) {
                    Text("Close")
                        .foregroundColor(.red)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(5)
                }
            }
            .frame(maxWidth: .infinity)
            .padding()
        }
        .padding()
        .background(.gray)
        .cornerRadius(15)
        
    }
}

struct BusbarTableView_Previews: PreviewProvider {
    static var previews: some View {
        BusbarTableView()
    }
}
