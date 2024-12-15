//
//  VoltageDrop.swift
//  CableCrossSection
//
//  Created by Ahmed Halilovic on 12. 11. 2024..
//

import SwiftUI

struct VoltageDropView: View {
    @EnvironmentObject var sharedData: SharedDataModel
    
    @State private var isManualEntry = false
    @State private var resultVoltageDrop: String = ""
    
    init() {
        
    }
    
    var body: some View {
        //NavigationStack {
            Form {
                Section {
                    VStack {
                        // Title and the Clear button
//                        HStack {
//                            Spacer() // Pushes the button to the right
//                            Button(action: {
//                                // Action to clear the input fields
//                                clearInputs()
//                            }) {
//                                Image(systemName: "trash.fill") // Trash icon
//                                    .resizable()
//                                    .scaledToFit()
//                                    .frame(width: 20, height: 20)
//                                    .padding()
//                            }
//                            .frame(maxWidth: .infinity, alignment: .trailing)
//                        }
//                        .padding(.horizontal)
                        
                        HStack {
                            Text("Power (kW)")
                                .font(.subheadline)
                                .frame(maxWidth: .infinity)
                            TextField("(kW)", text: $sharedData.powerKW)
                                .keyboardType(.numberPad)
                                .multilineTextAlignment(.center)
                                .padding(5)
                                .background(Color.white)
                                .cornerRadius(8)
                                .shadow(radius: 3)
                                .frame(maxWidth: .infinity)
                        }
                        HStack {
                            Text("Power factor (cos φ)")
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
                            Text("Voltage (V)")
                                .font(.subheadline)
                                .frame(maxWidth: .infinity)
                            TextField("Voltage", text: $sharedData.voltage)
                                .keyboardType(.numberPad)
                                .multilineTextAlignment(.center)
                                .padding(5)
                                .background(Color.white)
                                .cornerRadius(8)
                                .shadow(radius: 3)
                                .frame(maxWidth: .infinity)
                        }
                        HStack {
                            Text("Cable length (m)")
                                .font(.subheadline)
                                .frame(maxWidth: .infinity)
                            TextField("(m)", text: $sharedData.cableLength)
                                .keyboardType(.decimalPad)
                                .multilineTextAlignment(.center)
                                .padding(5)
                                .background(Color.white)
                                .cornerRadius(8)
                                .shadow(radius: 3)
                                .frame(maxWidth: .infinity)
                        }
                        HStack {
                            Text("Cable cross-section (mm2)")
                                .font(.subheadline)
                                .multilineTextAlignment(.center)
                                .frame(maxWidth: .infinity)
                            TextField("(mm2)", text: $sharedData.cableCrossSection)
                                .keyboardType(.numberPad)
                                .multilineTextAlignment(.center)
                                .padding(5)
                                .background(Color.white)
                                .cornerRadius(8)
                                .shadow(radius: 3)
                                .frame(maxWidth: .infinity)
                                .onTapGesture {
                                    sharedData.isManualEntryCrossSection = true
                                    print("Tapped")
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
                            print(sharedData.isManualEntryCrossSection)
                        }
                    }
                } header: {
                    Text("Input parameters")
                }

                Section {
                    VStack {
                        //Calculate button
                        HStack {
                            Spacer()
                            Button("Calculate") {
                                showResult()
                            }
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                            .fontWeight(.bold)
                            Spacer()
                        }

                        //Equation display
                        Text("ΔV = (√3 × I × R × L) / 1000")
                            .font(.system(size: 16, weight: .medium, design: .monospaced))
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.center)
                            .padding(.bottom, 10)

                        //Resul display
                        if !resultVoltageDrop.isEmpty {
                            Section {
                                Text(resultVoltageDrop)
                            } header: {
                                Text("Result")
                            }
                        }
                    }
                    .background(Color.clear)
                } header: {
                    Text("Result")
                }


            }
            //.keyboardToolbar()
        //}
    }
    
    private func updateCrossSectionBasedOnMaterial() {
        if sharedData.selectedMaterial == "Cu" {
            // Set the best copper cross-section if the material is Cu
            sharedData.cableCrossSection = sharedData.bestCopperCrossSection
            print(sharedData.bestCopperCrossSection)
        } else {
            // Set the best aluminum cross-section if the material is Al
            sharedData.cableCrossSection = sharedData.bestAluminumCrossSection
            print(sharedData.bestAluminumCrossSection)
        }
    }
    
    func showResult() {
        guard let power = Double(sharedData.powerKW),
              let voltageValue = Double(sharedData.voltage),
              let lengthValue = Double(sharedData.cableLength),
              let crossSectionValue = Double(sharedData.cableCrossSection) else {
            resultVoltageDrop = "Invalid input. Please enter valid numbers."
            return
        }
        
        //Calculate current
        let current = (power * 1000.0) / (voltageValue * sqrt(3) * sharedData.powerFactor)
        
        //Calculate voltage drop
        let conductivity: Double = sharedData.selectedMaterial == "Cu" ? 56.0 : 35.0 // S/mm² for Copper and Aluminum
        let voltageDropPercentage = calculateVoltageDrop(power: power, voltage: voltageValue, lengthValue: lengthValue, crossSection: crossSectionValue, conductivity: conductivity)
        
        
        // Calculate max cable length
        let maxCableLength = calculateMaxCableLength(power: power, voltageValue: voltageValue, voltageDropPercentage: 2.98, crossSectionValue: crossSectionValue, conductivity: conductivity)

        //Display results
        resultVoltageDrop = """
        Calculated Current: \(String(format: "%.2f", current)) A
        Voltage Drop: \(String(format: "%.2f", voltageDropPercentage)) %
        Maximum Cable length: \(String(format: "%.2f", maxCableLength)) m
        """
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
        sharedData.voltage = "400"
        sharedData.cableLength = ""
        sharedData.cableCrossSection = ""
        sharedData.selectedMaterial = "Cu"
        sharedData.isManualEntryCrossSection = false
    }
}

struct VoltageDropView_Previews: PreviewProvider {
    static var previews: some View {
        VoltageDropView()
    }
}
