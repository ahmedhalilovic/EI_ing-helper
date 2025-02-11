//
//  CompensationCalcuatorView.swift
//  CableCrossSection
//
//  Created by Ahmed Halilovic on 10. 12. 2024..
//

import SwiftUI

struct CompensationCalcuatorView: View {
    @EnvironmentObject var sharedData: SharedDataModel
    
    // Input fields
    @State private var activePower: String = "" // kW
    @State private var reactiveEnergy: String = "" // kVARh
    @State private var operatingHours: String = "" // hours
    @State private var targetPowerFactor: Double = 0 // e.g., 0.98

    // Output result
    @State private var requiredCapacitor: String = ""

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {

                // Input fields
                Group {
                    TextField("Active Power (kW)", text: $activePower)
                        .keyboardType(.decimalPad)
                        .textFieldStyle(RoundedBorderTextFieldStyle())

                    TextField("Reactive Energy (kVARh)", text: $reactiveEnergy)
                        .keyboardType(.decimalPad)
                        .textFieldStyle(RoundedBorderTextFieldStyle())

                    TextField("Operating Hours (hours)", text: $operatingHours)
                        .keyboardType(.decimalPad)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                    HStack {
                        Text(Bundle.localizedString(key: "power_factor_text"))
                            .font(.subheadline)
                            .multilineTextAlignment(.center)
                            .frame(maxWidth: .infinity)
                        HStack {
                            Picker("Power Factor (cos φ)", selection: $targetPowerFactor) {
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
                                if targetPowerFactor == 0 {
                                    targetPowerFactor = 0.99
                                }
                            }
                        }
                        
                    }
                }

                // Calculate Button
                Button(action: calculateCapacitorSize) {
                    Text("Calculate")
                        .font(.headline)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }

                // Display Result
                if !requiredCapacitor.isEmpty {
                    Text("Required Capacitor Size: \(requiredCapacitor) kVAR")
                        .font(.headline)
                        .padding()
                        .multilineTextAlignment(.center)
                }

                Spacer()
            }
            .padding()
            .navigationTitle(Bundle.localizedString(key: "compensation_sheet_name"))
        }
    }

    // Calculation Logic
    func calculateCapacitorSize() {
        guard let p = Double(activePower),
              let kvarh = Double(reactiveEnergy),
              let hours = Double(operatingHours),
              targetPowerFactor > 0, targetPowerFactor < 1 else {
            requiredCapacitor = "Invalid input. Please check your values."
            return
        }

        // Calculate existing reactive power
        let q1 = kvarh / hours

        // Calculate target reactive power
        let tanPhi1 = sqrt(1 / pow(0.993, 2) - 1) // Assuming initial PF is 0.993
        let tanPhi2 = sqrt(1 / pow(targetPowerFactor, 2) - 1)
        let q2 = p * tanPhi2

        // Required compensation
        let compensation = max(q1 - q2, 0)
        requiredCapacitor = String(format: "%.2f", compensation)
    }
}

// Preview
struct CompensationCalcuatorView_Previews: PreviewProvider {
    static var previews: some View {
        CompensationCalcuatorView()
    }
}
