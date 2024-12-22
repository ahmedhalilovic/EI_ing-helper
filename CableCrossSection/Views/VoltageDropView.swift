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
                    Text(Bundle.localizedString(key: "input_parameters"))
                }

                Section {
                    VStack {
                        //Calculate button
                        HStack {
                            Spacer()
                            Button(Bundle.localizedString(key: "calculate")) {
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

                        //Result display
                        if !resultVoltageDrop.isEmpty {
                            Section {
                                Text(resultVoltageDrop)
                            } header: {
                                Text(Bundle.localizedString(key: "result"))
                            }
                        }
                        VStack(spacing: 5) {
                            HStack {
                                VStack {
                                    Image(systemName: "bolt.fill") // Symbol for current
                                        .font(.system(size: 15))
                                        .foregroundColor(.blue)
                                    Text("Current")
                                        .font(.headline)
                                    Text("ahmed A")
                                        .font(.title2)
                                        .bold()
                                }
                                .frame(maxWidth: .infinity)

                                VStack {
                                    Image(systemName: "waveform.path.ecg") // Symbol for voltage drop
                                        .font(.system(size: 15))
                                        .foregroundColor(.green)
                                    Text("Voltage Drop")
                                        .font(.headline)
                                    Text("ahmed ")
                                        .font(.title2)
                                        .bold()
                                }
                                .frame(maxWidth: .infinity)
                            }
                            .padding()
                            .background(Color(UIColor.secondarySystemBackground))
                            .cornerRadius(8)

                            Divider()
                                .padding(.vertical, 5)

                            VStack {
                                Text("Maximum Cable Length")
                                    .font(.headline)
                                    .foregroundColor(.secondary)
                                Text("ahmed  m")
                                    .font(.title2)
                                    .bold()
                            }
                            .padding()
                            .background(Color(UIColor.secondarySystemBackground))
                            .cornerRadius(10)
                        }
                        .padding()

                    }
                    .background(Color.clear)
                } header: {
                    Text(Bundle.localizedString(key: "result"))
                }


            }
            //.keyboardToolbar()
        //}
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
