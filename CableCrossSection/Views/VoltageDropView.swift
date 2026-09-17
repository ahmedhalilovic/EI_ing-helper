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
                        Text("Power (kW)")
                            .font(.subheadline)
                            .frame(maxWidth: .infinity)
                        TextField("[kW]", text: $sharedData.powerKW)
                            .keyboardType(.decimalPad)
                            .onChange(of: sharedData.powerKW) { newValue in
                                let separator = Locale.current.decimalSeparator ?? "."
                                var filtered = newValue.filter { $0.isNumber || String($0) == separator }
                                if filtered.components(separatedBy: separator).count > 2 {
                                    var parts = filtered.components(separatedBy: separator)
                                    let first = parts.removeFirst()
                                    filtered = first + separator + parts.joined().replacingOccurrences(of: separator, with: "")
                                }
                                if filtered == separator { filtered = "0" + separator }
                                if filtered != newValue { sharedData.powerKW = filtered }
                            }
                            .multilineTextAlignment(.center)
                            .textInputAutocapitalization(.none)
                            .autocorrectionDisabled()
                            .padding(5)
                            .background(Color(.systemBackground))
                            .cornerRadius(8)
                            .shadow(radius: 3)
                            .frame(maxWidth: .infinity)
                            .focused($isPowerInputFieldFocused)
                    }
                    
                    HStack {
                        Text("Power factor (cos φ)")
                            .font(.subheadline)
                            .multilineTextAlignment(.center)
                            .frame(maxWidth: .infinity)
                        HStack {
                            Picker("Power Factor (cos φ)", selection: $sharedData.powerFactor) {
                                ForEach(80...100, id: \.self) { index in
                                    let value = Double(index) / 100.0
                                    Text(String(format: "%.2f", value))
                                        .tag(value)
                                }
                            }
                            .pickerStyle(WheelPickerStyle())
                            .frame(height: 80)
                            .frame(maxWidth: .infinity)
                            .onAppear {
                                if sharedData.powerFactor == 0 {
                                    sharedData.powerFactor = 0.95
                                }
                            }
                        }
                        
                    }
                    
                    HStack {
                        Text("Voltage (V)")
                            .font(.subheadline)
                            .frame(maxWidth: .infinity)
                        TextField("[V]", text: $sharedData.voltage)
                            .keyboardType(.numberPad)
                            .onChange(of: sharedData.voltage) { newValue in
                                let filtered = newValue.filter { $0.isNumber }
                                if filtered != newValue { sharedData.voltage = filtered }
                            }
                            .multilineTextAlignment(.center)
                            .padding(5)
                            .background(Color(.systemBackground))
                            .cornerRadius(8)
                            .shadow(radius: 3)
                            .frame(maxWidth: .infinity)
                    }
                    
                    HStack {
                        Text("Cable length (m)")
                            .font(.subheadline)
                            .frame(maxWidth: .infinity)
                        TextField("[m]", text: $sharedData.cableLength)
                            .keyboardType(.decimalPad)
                            .onChange(of: sharedData.cableLength) { newValue in
                                let separator = Locale.current.decimalSeparator ?? "."
                                var filtered = newValue.filter { $0.isNumber || String($0) == separator }
                                if filtered.components(separatedBy: separator).count > 2 {
                                    var parts = filtered.components(separatedBy: separator)
                                    let first = parts.removeFirst()
                                    filtered = first + separator + parts.joined().replacingOccurrences(of: separator, with: "")
                                }
                                if filtered == separator { filtered = "0" + separator }
                                if filtered != newValue { sharedData.cableLength = filtered }
                            }
                            .multilineTextAlignment(.center)
                            .padding(5)
                            .background(Color(.systemBackground))
                            .cornerRadius(8)
                            .shadow(radius: 3)
                            .frame(maxWidth: .infinity)
                    }
                    
                    HStack {
                        Text("Cable cross-section (mm2)")
                            .font(.subheadline)
                            .multilineTextAlignment(.center)
                            .frame(maxWidth: .infinity)
                        TextField("[mm2]", text: $sharedData.cableCrossSection)
                            .keyboardType(.numberPad)
                            .onChange(of: sharedData.cableCrossSection) { newValue in
                                let filtered = newValue.filter { $0.isNumber }
                                if filtered != newValue { sharedData.cableCrossSection = filtered }
                            }
                            .multilineTextAlignment(.center)
                            .padding(5)
                            .background(Color(.systemBackground))
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
                .keyboardToolbar()
                
                //Cable conductivity picker
                VStack {
                    Text("Conductivity:")
                        .font(.subheadline)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Picker("Cable material (Sm/mm2)", selection: $sharedData.selectedMaterial) {
                        Text("Copper = 56").tag("Cu")
                        Text("Aluminum = 35").tag("Al")
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .onChange(of: sharedData.selectedMaterial) { newValue in
                        if !sharedData.isManualEntryCrossSection {
                            updateCrossSectionBasedOnMaterial()
                        }
                    }
                }
                
                HStack {
                    Spacer()
                    Button(action: {
                        isPowerInputFieldFocused = false
                        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                        showResult()
                    }) {
                        Text("Calculate")
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                            .fontWeight(.bold)
                    }
                    .buttonStyle(PlainButtonStyle())
                    Spacer()
                }
            } header: {
                HStack { // Title and the Clear button
                    Text("Input parameters")
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
                    //Result display
                    if !resultVoltageDrop.isEmpty {
                        Section {
                            Text(resultVoltageDrop)
                        } header: {
                            Text("Result")
                        }
                    }
                    
                    VStack(alignment: .leading, spacing: 16) {
                        // Inline result for Current and Voltage Drop
                        HStack {
                            VStack(alignment: .leading) {
                                Text("Current: ")
                                    .font(.headline)
                                Text("\(sharedData.calculatedCurrent, specifier: "%.2f") A")
                                    .font(.body)
                                    .bold()
                            }
                            Spacer()
                            VStack(alignment: .leading) {
                                Text("Voltage Drop: ")
                                    .font(.headline)
                                Text("\(sharedData.voltageDrop, specifier: "%.2f") %")
                                    .font(.body)
                                    .bold()
                            }
                        }

                        // Overlapping Max Cable Length vs Input Cable Length
                        VStack(alignment: .leading) {
                            Text("Maximum Cable length: ")
                                .font(.headline)
                            
                            ZStack(alignment: .leading) {
                                GeometryReader { geometry in
                                    let maxBarWidth = geometry.size.width
                                    let safeMaxCableLength = max(maxCableLengthForResult, 1) // Prevent division by zero
                                    let isOverMax = cableLengthForResult > maxCableLengthForResult
                                    let proportionalInputWidth = min(max(0, (cableLengthForResult / safeMaxCableLength) * maxBarWidth), maxBarWidth)
                                    
                                    Rectangle()
                                        .fill(Color.gray.opacity(0.4))
                                        .frame(width: maxBarWidth, height: 20)
                                    
                                    Rectangle()
                                        .fill(isOverMax ? Color.red.opacity(0.7) : Color.green.opacity(0.7))
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
                    Text("Result")
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
                    .sheet(isPresented: $infoDialogIsPresented) {
                        VStack(spacing: 32) {
                            Text("Equation used")
                                .font(.title2)
                                .fontWeight(.semibold)

                            HStack(alignment: .center, spacing: 10) {
                                Text("ΔV [%] =")
                                    .font(.system(size: 20, weight: .medium, design: .monospaced))

                                VStack(spacing: 4) {
                                    Text("√3 × I × R × L")
                                        .font(.system(size: 18, weight: .medium, design: .monospaced))
                                    Rectangle()
                                        .frame(height: 1.5)
                                    Text("1000")
                                        .font(.system(size: 18, weight: .medium, design: .monospaced))
                                }
                            }
                            .padding(.horizontal)

                            Button(action: { infoDialogIsPresented = false }) {
                                Text("OK")
                                    .fontWeight(.semibold)
                                    .foregroundColor(.white)
                                    .frame(width: 120)
                                    .padding(.vertical, 10)
                                    .background(Color.red)
                                    .cornerRadius(10)
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(.regularMaterial)
                        .presentationDetents([.fraction(0.35)])
                        .presentationDragIndicator(.visible)
                    }

                }
            }
        }
        .scrollDismissesKeyboard(.interactively)
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
        guard let power = parseDouble(sharedData.powerKW),
              let voltageValue = parseDouble(sharedData.voltage),
              let lengthValue = parseDouble(sharedData.cableLength),
              let crossSectionValue = parseDouble(sharedData.cableCrossSection) else {
            resultVoltageDrop = "Invalid input. Please enter valid numbers."
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
        cableLengthForResult = parseDouble(sharedData.cableLength) ?? 0
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
        let model = SharedDataModel()
        return VoltageDropView()
            .environmentObject(model)
    }
}

