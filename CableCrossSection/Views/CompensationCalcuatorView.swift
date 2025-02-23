//
//  CompensationCalcuatorView.swift
//  CableCrossSection
//
//  Created by Ahmed Halilovic on 10. 12. 2024..
//

import SwiftUI

struct CompensationCalcuatorView: View {
    @FocusState private var isPowerInputFieldFocused: Bool
    @EnvironmentObject var sharedData: SharedDataModel
    
    // Input fields
    @State private var activePower: String = "" // kW
    @State private var reactiveEnergy: String = "" // kVARh
    @State private var operatingHours: String = "" // hours
    @State private var targetPowerFactor: Double = 0 // e.g., 0.98
    @State private var infoDialogIsPresented: Bool = false

    // Output result
    @State private var requiredCapacitor: String = ""

    var body: some View {
        NavigationStack {
            Form {
                // MARK: Input section
                Section {
                    
                    // Input fields
                    Group {
                        HStack {
                            Text(Bundle.localizedString(key: "power_text"))
                                .font(.subheadline)
                                .frame(maxWidth: .infinity)
                            TextField("[kW]", text: $activePower)
                                .keyboardType(.decimalPad)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .focused($isPowerInputFieldFocused)
                        }
                        HStack {
                            Text(Bundle.localizedString(key: "reactive_energy_text"))
                                .font(.subheadline)
                                .frame(maxWidth: .infinity)
                            TextField("[kVARh]", text: $reactiveEnergy)
                                .keyboardType(.decimalPad)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                        }
                        HStack {
                            Text(Bundle.localizedString(key: "operating_hours_text"))
                                .font(.subheadline)
                                .frame(maxWidth: .infinity)
                            TextField("[h]", text: $operatingHours)
                                .keyboardType(.decimalPad)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                        }
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
                    .buttonStyle(PlainButtonStyle())

                    Spacer()
                } header: {
                    HStack {
                        Text(Bundle.localizedString(key: "input_parameters"))
                        Button(action: {
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
                
                // MARK: Result section
                Section { // Display result
                    VStack {
                        Text("Required Capacitor Size:")
                            .font(.headline)
                            .multilineTextAlignment(.center)
                    }
                    VStack {
                        if !requiredCapacitor.isEmpty {
                            Text("\(requiredCapacitor)")
                                .font(.largeTitle)
                                .fontWeight(.bold)
                                .multilineTextAlignment(.center)
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                    
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
                            Text("""
                            Existing Reactive Power:
                            Q₁ = kVARh / Hours
                            
                            Target Reactive Power:
                            Q₂ = P × tan(φ₂),
                            where tan(φ) = sqrt(1 / cos²(φ) - 1)
                            
                            Required Compensation:
                            Qcomp = max(Q₁ - Q₂, 0)
                            """)
                            .font(.system(size: 16, weight: .medium, design: .monospaced))
                            .foregroundColor(.gray)
                                .multilineTextAlignment(.center)
                                .padding(20)
                        }

                    }
                }
            }
            .navigationTitle(Bundle.localizedString(key: "compensation_sheet_name")) // Adds title to sheet
            .navigationBarTitleDisplayMode(.inline) // Makes title smaller and centered
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    isPowerInputFieldFocused = true
                }
            }
        }
    }
    
    // MARK: Functions
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
        _ = sqrt(1 / pow(0.993, 2) - 1) // Assuming initial PF is 0.993
        let tanPhi2 = sqrt(1 / pow(targetPowerFactor, 2) - 1)
        let q2 = p * tanPhi2

        // Required compensation
        let compensation = max(q1 - q2, 0)
        requiredCapacitor = String(format: "%.2f kVAR", compensation)
    }
    
    // Clear Function
    private func clearInputs() {
        activePower = ""
        reactiveEnergy = ""
        operatingHours = ""
        targetPowerFactor = 0.99
        requiredCapacitor = ""
        
    }
}

// Preview
struct CompensationCalcuatorView_Previews: PreviewProvider {
    static var previews: some View {
        CompensationCalcuatorView()
    }
}
