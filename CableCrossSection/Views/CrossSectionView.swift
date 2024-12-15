//
//  CrossSectionView.swift
//  CableCrossSection
//
//  Created by Ahmed Halilovic on 12. 11. 2024..
//

import SwiftUI
import Foundation

struct CrossSectionView: View {
    @EnvironmentObject var sharedData: SharedDataModel
    
//    @State private var powerKW = ""
//    @State private var powerFactor: Double = 0.95
    @State private var resultCurrent1Phase: String? = nil
    @State private var resultCurrent3Phase: String? = nil
    @State private var resultRecomendedCableCu: String? = nil
    @State private var resultRecomendedCableAl: String? = nil
    
    var body: some View {
            Form {
                Section {
                    HStack {
                        Group {
                            InputField(title: "Power (kW)", text: $sharedData.powerKW)
                            //.keyboardToolbar()
                            Picker("Power factor (cos φ)",
                                   selection: $sharedData.powerFactor) {
                                ForEach(0...100, id: \.self) { index in
                                    let value = Double(index) / 100.0
                                    Text(String(format: "%.2f", value))
                                        .tag(value)
                                }
                            }
                                   .pickerStyle(WheelPickerStyle())
                                   .frame(height: 120)
                                   .background(Color.white)
                                   .frame(maxWidth: .infinity)
                                   .onAppear {
                                       if sharedData.powerFactor == 0 {
                                           sharedData.powerFactor = 0.95
                                       }
                                   }
                        }
                    }
                    //VStack {
                        HStack {
                            // Calculate button
                            Button(action: {
                                calculateCurrent()
                                sharedData.showBusbarButton = true // Show the busbar button after calculation
                                print(sharedData.showBusbarSheet)
                            }) {
                                Text("Calculate")
                                    .font(.headline)
                                    .padding()
                                    .background(Color.blue)
                                    .foregroundColor(.white)
                                    .cornerRadius(8)
                            }
                            
                            
                            
                        }
                    // The busbar button will appear after calculation button
                    Button(action: {
                        sharedData.showBusbarSheet = true // Show the sheet when the button is pressed
                    }) {
                        Image(systemName: "table")
                            .foregroundColor(.blue)
                            .padding()
                            .background(Color.gray.opacity(0.2))
                            .cornerRadius(8)
                    }
                    .opacity(sharedData.showBusbarButton ? 1 : 0)
                    .animation(.easeInOut, value: sharedData.showBusbarButton)
                    .transition(.opacity)
                    .sheet(isPresented: $sharedData.showBusbarSheet) { // Display sheet when button is pressed
                        BusbarTableView()
                            .presentationDetents([.medium, .large]) // Takse half screen by default, can be expanded to fit whole screen
                            .presentationDragIndicator(.visible) // Adds a drag indicator
                    }
                    //}
                    
                } header: {
                    Text("Input parameters")
                    
                }
                
                // Result display (currents, recomended cross-secton and fuses)
                Section {
                    
                    VStack(spacing: 20) {
                        // Current Results
                        VStack(alignment: .leading, spacing: 10) {
                            HStack {
                                Image(systemName: "bolt.fill")
                                    .foregroundColor(.yellow)
                                Text("1-Phase Current:")
                                    .bold()
                                Spacer()
                                Text(resultCurrent1Phase ?? "- A")
                                    .foregroundColor(.blue)
                            }
                            .padding()
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(8)
                            
                            HStack {
                                Image(systemName: "bolt.circle.fill")
                                    .foregroundColor(.orange)
                                Text("3-Phase Current:")
                                    .bold()
                                Spacer()
                                Text(resultCurrent3Phase ?? "- A")
                                    .foregroundColor(.blue)
                            }
                            .padding()
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(8)
                        }
                        
                        // Copper Results
                        VStack(alignment: .leading, spacing: 10) {
                            HStack {
                                Image(systemName: "c.square.fill")
                                    .foregroundColor(.brown)
                                Text("Copper:")
                                    .bold()
                                Spacer()
                                Text(resultRecomendedCableCu ?? "⌀: -, Fuse: -")
                                    .foregroundColor(.green)
                            }
                            .padding()
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(8)
                        }
                        
                        // Aluminum Results
                        VStack(alignment: .leading, spacing: 10) {
                            HStack {
                                Image(systemName: "a.square.fill")
                                    .foregroundColor(.gray)
                                Text("Aluminum:")
                                    .bold()
                                Spacer()
                                Text(resultRecomendedCableAl ?? "⌀: -, Fuse: -")
                                    .foregroundColor(.green)
                            }
                            .padding()
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(8)
                        }
                    }

                    Spacer()

                    } header: {
                        Text("Results")
                    }
                    
                }
                //.padding()
        }
    
    // Calculation logic
    private func calculateCurrent() {
        guard let power = Double(sharedData.powerKW),
              power > 0 else {
            resultCurrent1Phase = "Invalid input."
            return
        }
        
        // Current calculation
        let current1f = power * 1000 / (230 * sharedData.powerFactor)
        let current3f = power * 1000 / (sqrt(3) * 400 * sharedData.powerFactor)
        
        resultCurrent1Phase = String(format: "%.2f A", current1f)
        resultCurrent3Phase = String(format: "%.2f A", current3f)
        
        // Filter options for copper and aluminum
        let copperOptions = CableLoadData.cableData.filter{
            (Double($0.fuseForCu) ?? 0) >= current3f
        }
        
        let aluminumOptions = CableLoadData.cableData.filter {
            (Double($0.fuseForAl) ?? 0) >= current3f
        }
        
        // Get the closest three options
        let closestCopperOptions = Array(copperOptions.prefix(3))
        let closestAluminumOptions = Array(aluminumOptions.prefix(3))
        
        // Determine the best fit for copper
        if let copperBest = findBestOption(for: current3f, options: closestCopperOptions, keyPath: \.fuseForCu) {
            resultRecomendedCableCu = "⌀: \(copperBest.crossSection) mm2, Fuse: \(copperBest.fuseForCu) A"
            sharedData.bestCopperCrossSection = copperBest.crossSection
        } else {
            resultRecomendedCableCu = "No suitable copper cable found."
        }
        
        if let aluminumBest = findBestOption(for: current3f, options: closestAluminumOptions, keyPath: \.fuseForAl) {
            resultRecomendedCableAl = "⌀: \(aluminumBest.crossSection) mm2, Fuse: \(aluminumBest.fuseForAl) A"
            sharedData.bestAluminumCrossSection = aluminumBest.crossSection
        } else {
            resultRecomendedCableAl = "No suitable copper cable found."
        }
        
        // Update the best suited crosssection and fuses in Table Tab
        sharedData.selectedCopperRow = findBestOption(for: current3f, options: closestCopperOptions, keyPath: \.fuseForCu)
        sharedData.selectedAluminumRow = findBestOption(for: current3f, options: closestAluminumOptions, keyPath: \.fuseForAl)
        
        sharedData.isManualEntryCrossSection = false // Reset to false when current is calculated again
    }
    
    private func findBestOption(for current: Double, options: [DataVariables], keyPath: KeyPath<DataVariables, String>) -> DataVariables? {
        guard !options.isEmpty else { return nil }
        
        // Calculate proximity to each option
        let withProximity = options.compactMap { option -> (option: DataVariables, proximity: Double)? in
            guard let maxCurrent = Double(option[keyPath: keyPath]) else { return nil }
            return (option, abs(maxCurrent - current))
        }
        
        // Sort by proximity
        let sorted = withProximity.sorted(by: { $0.proximity < $1.proximity })
        
        // Ensure we pick a slightly larger option if close to the smaller one
        if let closest = sorted.first,
           let secondClosest = sorted.dropFirst().first {
            let closestCurrent = Double(closest.option[keyPath: keyPath])!
            //let secondClosestCurrent = Double(secondClosest.option[keyPath: keyPath])!

            // If the current is closer to the smaller option but exceeds 90% of its value, prefer the larger option
            if current >= closestCurrent * 0.9 && current < closestCurrent {
                return secondClosest.option
            }
        }
        
        return sorted.first?.option
    }
}

struct InputField: View {
    let title: String
    @Binding var text: String

    var body: some View {
        HStack {
            Text(title)
                .font(.subheadline)
                .foregroundColor(.gray)
            TextField(title, text: $text)
                .keyboardType(.decimalPad)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(8)

        }
    }
}

struct CrossSectionView_Previews: PreviewProvider {
    static var previews: some View {
        CrossSectionView()
    }
}
