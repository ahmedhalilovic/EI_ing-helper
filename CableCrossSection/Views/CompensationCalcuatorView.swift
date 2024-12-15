//
//  CompensationCalcuatorView.swift
//  CableCrossSection
//
//  Created by Ahmed Halilovic on 10. 12. 2024..
//

import SwiftUI

struct CompensationCalcuatorView: View {
    // Input fields
    @State private var activePower: String = "" // kW
    @State private var reactiveEnergy: String = "" // kVARh
    @State private var operatingHours: String = "" // hours
    @State private var targetPowerFactor: String = "" // e.g., 0.98

    // Output result
    @State private var requiredCapacitor: String = ""

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text("Capacitor Size Calculator")
                    .font(.title)
                    .bold()

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

                    TextField("Target Power Factor (e.g., 0.98)", text: $targetPowerFactor)
                        .keyboardType(.decimalPad)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
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
            .navigationTitle("Capacitor Calculator")
        }
    }

    // Calculation Logic
    func calculateCapacitorSize() {
        guard let p = Double(activePower),
              let kvarh = Double(reactiveEnergy),
              let hours = Double(operatingHours),
              let targetPF = Double(targetPowerFactor),
              targetPF > 0, targetPF < 1 else {
            requiredCapacitor = "Invalid input. Please check your values."
            return
        }

        // Calculate existing reactive power
        let q1 = kvarh / hours

        // Calculate target reactive power
        let tanPhi1 = sqrt(1 / pow(0.993, 2) - 1) // Assuming initial PF is 0.993
        let tanPhi2 = sqrt(1 / pow(targetPF, 2) - 1)
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
