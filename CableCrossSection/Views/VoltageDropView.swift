//
//  VoltageDrop.swift
//  CableCrossSection
//
//  Created by Ahmed Halilovic on 12. 11. 2024..
//

import SwiftUI

struct VoltageDropView: View {
    @FocusState private var isPowerInputFieldFocused: Bool
    @EnvironmentObject var sharedData: SharedDataModel
    
    @State private var isManualEntry = false
    @State private var resultVoltageDrop: String = ""
    @State private var cableLengthForResult: Double = 0
    @State private var maxCableLengthForResult: Double = 0
    @State private var infoDialogIsPresented: Bool = false
    @State private var maxBarWidth: CGFloat = 0
    @State private var proportionalInputWidth: CGFloat = 0
    
    init() {
        
    }
    
    var body: some View {
        Form {
            Section { // MARK: Input section
                VStack {
                    HStack {
                        Text(Bundle.localizedString(key: "power_text"))
                            .font(.subheadline)
                            .frame(maxWidth: .infinity)
                        TextField("[kW]", text: $sharedData.powerKW)
                            .keyboardType(.numberPad)
                            .multilineTextAlignment(.center)
                            .padding(5)
                            .background(Color.white)
                            .cornerRadius(8)
                            .shadow(radius: 3)
                            .frame(maxWidth: .infinity)
                            .focused($isPowerInputFieldFocused)
                    }
                    HStack {
                        Text(Bundle.localizedString(key: "power_factor_text"))
                            .font(.subheadline)
                            .multilineTextAlignment(.center)
                            .frame(maxWidth: .infinity)
                        HStack {
                            Picker("Power Factor (cos φ)", selection: $sharedData.powerFactor) {
                                ForEach(0...100, id: \.self) { index in
                                    let value = Double(index) / 100.0
                                    Text(String(format: "%.2f", value))
                                        .tag(value)
                                }
                            }
                            .pickerStyle(WheelPickerStyle())
                            .frame(height: 80)
                            .background(Color.white)
                            .frame(maxWidth: .infinity)
                            .onAppear {
                                if sharedData.powerFactor == 0 {
                                    sharedData.powerFactor = 0.95
                                }
                            }
                        }
                        
                    }
                    HStack {
                        Text(Bundle.localizedString(key: "voltage_text"))
                            .font(.subheadline)
                            .frame(maxWidth: .infinity)
                        TextField("[V]", text: $sharedData.voltage)
                            .keyboardType(.numberPad)
                            .multilineTextAlignment(.center)
                            .padding(5)
                            .background(Color.white)
                            .cornerRadius(8)
                            .shadow(radius: 3)
                            .frame(maxWidth: .infinity)
                    }
                    HStack {
                        Text(Bundle.localizedString(key: "cable_length_text"))
                            .font(.subheadline)
                            .frame(maxWidth: .infinity)
                        TextField("[m]", text: $sharedData.cableLength)
                            .keyboardType(.decimalPad)
                            .multilineTextAlignment(.center)
                            .padding(5)
                            .background(Color.white)
                            .cornerRadius(8)
                            .shadow(radius: 3)
                            .frame(maxWidth: .infinity)
                    }
                    HStack {
                        Text(Bundle.localizedString(key: "cable_cross_section_text"))
                            .font(.subheadline)
                            .multilineTextAlignment(.center)
                            .frame(maxWidth: .infinity)
                        TextField("[mm2]", text: $sharedData.cableCrossSection)
                            .keyboardType(.numberPad)
                            .multilineTextAlignment(.center)
                            .padding(5)
                            .background(Color.white)
                            .cornerRadius(8)
                            .shadow(radius: 3)
                            .frame(maxWidth: .infinity)
                            .onTapGesture {
                                sharedData.isManualEntryCrossSection = true
                            }
                            .onAppear {
                                if !sharedData.isManualEntryCrossSection {
                                    updateCrossSectionBasedOnMaterial() // Automatically set the cross-section based on material and conductivity
                                }
                            }
                    }
                    
                }
                
                //Cable conductivity picker
                VStack {
                    Text(Bundle.localizedString(key: "condictivity_text"))
                        .font(.subheadline)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Picker("Cable material (Sm/mm2)", selection: $sharedData.selectedMaterial) {
                        Text(Bundle.localizedString(key: "picker_copper")).tag("Cu")
                        Text(Bundle.localizedString(key: "picker_aluminum")).tag("Al")
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .onChange(of: sharedData.selectedMaterial) { newValue in
                        if !sharedData.isManualEntryCrossSection {
                            updateCrossSectionBasedOnMaterial()
                        }
                    }
                }
            } header: {
                HStack { // Title and the Clear button
                    Text(Bundle.localizedString(key: "input_parameters"))
                    Button(action: {
                        // Action to clear the input fields
                        clearInputs()
                    }) {
                        Image(systemName: "trash.fill") // Trash icon
                            .resizable()
                            .scaledToFit()
                            .frame(width: 20, height: 20)
                            .padding(0)
                    }
                    .frame(maxWidth: .infinity, alignment: .trailing)
                }
            }
            //}
            // MARK: Result section
            Section {
                VStack {
                    //Calculate button
                    HStack(spacing: 20) {
                        Button(action: {
                            showResult()
                        }) {
                            Text(Bundle.localizedString(key: "calculate"))
                                .padding()
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(8)
                                .fontWeight(.bold)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                    
                    //Result display
                    if !resultVoltageDrop.isEmpty {
                        Section {
                            Text(resultVoltageDrop)
                        } header: {
                            Text(Bundle.localizedString(key: "result"))
                        }
                    }
                    
                    VStack(alignment: .leading, spacing: 16) {
                        // Inline result for Current and Voltage Drop
                        HStack {
                            VStack(alignment: .leading) {
                                Text(Bundle.localizedString(key: "result_current"))
                                    .font(.headline)
                                Text("\(sharedData.calculatedCurrent, specifier: "%.2f") A")
                                    .font(.body)
                                    .bold()
                            }
                            Spacer()
                            VStack(alignment: .leading) {
                                Text(Bundle.localizedString(key: "result_voltage"))
                                    .font(.headline)
                                Text("\(sharedData.voltageDrop, specifier: "%.2f") %")
                                    .font(.body)
                                    .bold()
                            }
                        }

                        // Overlapping Max Cable Length vs Input Cable Length
                        VStack(alignment: .leading) {
                            Text(Bundle.localizedString(key: "result_max_cable_length"))
                                .font(.headline)
                            
                            ZStack(alignment: .leading) {
                                GeometryReader { geometry in
                                    let maxBarWidth = geometry.size.width
                                    let safeMaxCableLength = max(maxCableLengthForResult, 1) // Prevent division by zero
                                    let proportionalInputWidth = max(0, (cableLengthForResult / safeMaxCableLength) * maxBarWidth) // Ensure non-negative
                                    
                                    Rectangle()
                                        .fill(Color.gray.opacity(0.4))
                                        .frame(width: maxBarWidth, height: 20)
                                    
                                    Rectangle()
                                        .fill(Color.green.opacity(0.7))
                                        .frame(width: proportionalInputWidth, height: 20)
                                }
                                .frame(height: 20) // Ensures the GeometryReader height remains constrained
                            }
                            
                            HStack {
                                Text("Used: \(cableLengthForResult, specifier: "%.1f") m")
                                Spacer()
                                Text("Max: \(maxCableLengthForResult, specifier: "%.1f") m")
                            }
                            .font(.caption)
                        }
                    }
                    .padding()
                }
                .background(Color.clear)
            } header: {
                HStack {
                    Text(Bundle.localizedString(key: "result"))
                    Button(action: {
                        // Equation display
                        infoDialogIsPresented = true
                    }) {
                        Image(systemName: "info.bubble") // Trash icon
                            .resizable()
                            .scaledToFit()
                            .frame(width: 20, height: 20)
                            .padding(0)
                    }
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    .alert("Equation used", isPresented: $infoDialogIsPresented) {
                        Button("OK", role: .cancel) { }
                    } message: {
                        Text("ΔV = (√3 × I × R × L) / 1000")
                            .font(.system(size: 16, weight: .medium, design: .monospaced))
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.center)
                            .padding(20)
                    }

                }
            }
        }
        .onAppear{
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                isPowerInputFieldFocused = true
            }
        }
    }
    
    private func updateCrossSectionBasedOnMaterial() {
        if sharedData.selectedMaterial == "Cu" {
            // Set the best copper cross-section if the material is Cu
            sharedData.cableCrossSection = sharedData.bestCopperCrossSection
        } else {
            // Set the best aluminum cross-section if the material is Al
            sharedData.cableCrossSection = sharedData.bestAluminumCrossSection
        }
    }
    
    func showResult() {
        guard let power = Double(sharedData.powerKW),
              let voltageValue = Double(sharedData.voltage),
              let lengthValue = Double(sharedData.cableLength),
              let crossSectionValue = Double(sharedData.cableCrossSection) else {
            resultVoltageDrop = Bundle.localizedString(key: "result_voltage_drop_invalid")
            return
        }
        
        //Calculate current
        sharedData.calculatedCurrent = (power * 1000.0) / (voltageValue * sqrt(3) * sharedData.powerFactor)
        
        //Calculate voltage drop
        let conductivity: Double = sharedData.selectedMaterial == "Cu" ? 56.0 : 35.0 // S/mm² for Copper and Aluminum
        sharedData.voltageDrop = calculateVoltageDrop(power: power, voltage: voltageValue, lengthValue: lengthValue, crossSection: crossSectionValue, conductivity: conductivity)
        
        // Calculate max cable length
        let maxCableLength = calculateMaxCableLength(power: power, voltageValue: voltageValue, voltageDropPercentage: 2.98, crossSectionValue: crossSectionValue, conductivity: conductivity)
        
        // Helper Function for Bar Width Calculation
        func calculateBarWidth(for length: Double) -> CGFloat {
            let maxBarWidth: CGFloat = 50 // Adjust based on your layout
            print(maxBarWidth)
            let maxLength: Double = lengthValue
            guard maxLength > 0 else { return 0 }
            return CGFloat(length / maxLength) * maxBarWidth
        }
        cableLengthForResult = Double(sharedData.cableLength) ?? 0
        maxCableLengthForResult = maxCableLength
        
        // Filter options for copper and aluminum
        let copperOptions = CableLoadData.cableData.filter{
            (Double($0.fuseForCu) ?? 0) >= sharedData.calculatedCurrent
        }
        
        let aluminumOptions = CableLoadData.cableData.filter {
            (Double($0.fuseForAl) ?? 0) >= sharedData.calculatedCurrent
        }
        // Get the closest three options
        let closestCopperOptions = Array(copperOptions.prefix(3))
        let closestAluminumOptions = Array(aluminumOptions.prefix(3))
        // Update the best suited crosssection and fuses in Table Tab
        sharedData.selectedCopperRow = findBestOption(for: sharedData.calculatedCurrent, options: closestCopperOptions, keyPath: \.fuseForCu)
        sharedData.selectedAluminumRow = findBestOption(for: sharedData.calculatedCurrent, options: closestAluminumOptions, keyPath: \.fuseForAl)
    }
    
    func calculateVoltageDrop(power: Double, voltage: Double, lengthValue: Double, crossSection: Double, conductivity: Double) -> Double{

        let voltageDropPercentageNumerator = (100 * lengthValue * (power * 1000)) // Numerator
        let voltageDropPercentageDenumerator = (conductivity * crossSection * pow(voltage, 2)) // Denumerator
        
        
        return voltageDropPercentageNumerator / voltageDropPercentageDenumerator
    }
    
    func calculateMaxCableLength(power: Double, voltageValue: Double, voltageDropPercentage: Double, crossSectionValue: Double, conductivity: Double) -> Double {
        
        let powerInWatts = power * 1000
        let numerator = (voltageDropPercentage * conductivity * crossSectionValue * pow(voltageValue, 2))
        let denumerator = 100 * powerInWatts

        // Calculate max cable length
        return numerator / denumerator
    }
    
    // Clear Function
    private func clearInputs() {
        sharedData.powerKW = ""
        sharedData.powerFactor = 0.95
        sharedData.voltage = "400"
        sharedData.cableLength = ""
        sharedData.cableCrossSection = ""
        sharedData.selectedMaterial = "Cu"
        resultVoltageDrop = ""
        cableLengthForResult = 0
        maxCableLengthForResult = 0
        sharedData.bestCopperCrossSection = ""
        sharedData.bestAluminumCrossSection = ""
        sharedData.isManualEntryCrossSection = false
        sharedData.selectedCopperRow = nil
        sharedData.selectedAluminumRow = nil
        sharedData.selectedBusbarRow = nil
        sharedData.calculatedCurrent = 0
        sharedData.voltageDrop = 0
        maxBarWidth = 0
        proportionalInputWidth = 0
    }
}

struct VoltageDropView_Previews: PreviewProvider {
    static var previews: some View {
        VoltageDropView()
    }
}
