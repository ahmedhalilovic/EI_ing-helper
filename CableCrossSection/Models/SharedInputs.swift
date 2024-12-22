//
//  SharedInputs.swift
//  CableCrossSection
//
//  Created by Ahmed Halilovic on 7. 12. 2024..
//

import SwiftUI

class SharedDataModel: ObservableObject {
    @Published var powerKW: String = "" //Double = 0.0
    @Published var powerFactor: Double = 0.95
    @Published var voltage: String = "400"
    @Published var cableLength: String = ""
    @Published var cableCrossSection: String = ""
    @Published var selectedMaterial: String = "Cu"
    
    @Published var selectedCopperRow: DataVariables?
    @Published var selectedAluminumRow: DataVariables?
    @Published var selectedBusbarRow: BusbarDataVariables?
    @Published var bestCopperCrossSection: String = ""
    @Published var bestAluminumCrossSection: String = ""
    @Published var bestSuitableBusbar: String = ""
    @Published var isManualEntryCrossSection = false
    @Published var showBusbarButton = false
    @Published var showBusbarSheet = false
}
