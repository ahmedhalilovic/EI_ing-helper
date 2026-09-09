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
    @State private var calculationError: String = ""

    var body: some View {
        ZStack {
          NavigationStack {
            Form {
                // MARK: Input section
                Section {
                    
                    // Input fields
                    Group {
                        HStack {
                            Text("Power (kW)")
                                .font(.subheadline)
                                .frame(maxWidth: .infinity)
                            TextField("[kW]", text: $activePower)
                                .keyboardType(.decimalPad)
                                .multilineTextAlignment(.center)
                                .padding(5)
                                .background(Color(.systemBackground))
                                .cornerRadius(8)
                                .shadow(radius: 3)
                                .frame(maxWidth: .infinity)
                                .focused($isPowerInputFieldFocused)
                        }
                        HStack {
                            Text("Reactive Energy (kVAR)")
                                .font(.subheadline)
                                .frame(maxWidth: .infinity)
                            TextField("[kVARh]", text: $reactiveEnergy)
                                .keyboardType(.decimalPad)
                                .multilineTextAlignment(.center)
                                .padding(5)
                                .background(Color(.systemBackground))
                                .cornerRadius(8)
                                .shadow(radius: 3)
                                .frame(maxWidth: .infinity)
                        }
                        HStack {
                            Text("Operating Hours")
                                .font(.subheadline)
                                .frame(maxWidth: .infinity)
                            TextField("[h]", text: $operatingHours)
                                .keyboardType(.decimalPad)
                                .multilineTextAlignment(.center)
                                .padding(5)
                                .background(Color(.systemBackground))
                                .cornerRadius(8)
                                .shadow(radius: 3)
                                .frame(maxWidth: .infinity)
                        }
                        HStack {
                            Text("Power factor (cos φ)")
                                .font(.subheadline)
                                .multilineTextAlignment(.center)
                                .frame(maxWidth: .infinity)
                            Picker("Power Factor (cos φ)", selection: $targetPowerFactor) {
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
                                if targetPowerFactor == 0 {
                                    targetPowerFactor = 0.99
                                }
                            }
                        }
                    }
                    
                    // Calculate Button
                    HStack {
                        Spacer()
                        Button(action: calculateCapacitorSize) {
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
                    HStack {
                        Text("Input parameters")
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
                        Text("Required Capacitor Battery Size:")
                            .font(.headline)
                            .multilineTextAlignment(.center)
                    }
                    VStack(spacing: 8) {
                        if !calculationError.isEmpty {
                            Text(calculationError)
                                .font(.footnote)
                                .foregroundColor(.blue)
                                .multilineTextAlignment(.center)
                        }
                        if !requiredCapacitor.isEmpty {
                            Text(requiredCapacitor)
                                .font(.largeTitle)
                                .fontWeight(.bold)
                                .multilineTextAlignment(.center)
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                    
                } header: {
                    HStack {
                        Text("Result")
                        Button(action: {
                            // Equation display
//                            isPowerInputFieldFocused = false
//                            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                            infoDialogIsPresented = true
                        }) {
                            Image(systemName: "info.bubble") // Trash icon
                                .resizable()
                                .scaledToFit()
                                .frame(width: 20, height: 20)
                                .padding(0)
                        }
                        .frame(maxWidth: .infinity, alignment: .trailing)


                    }
                }
            }
            .navigationTitle("Compensation Calculator")
            .navigationBarTitleDisplayMode(.inline)
          }

          // Overlay equation card
          if infoDialogIsPresented {
              Color.black.opacity(0.35)
                  .ignoresSafeArea()
                  .onTapGesture { withAnimation { infoDialogIsPresented = false } }

              VStack(alignment: .leading, spacing: 16) {
                  Text("Equation used")
                      .font(.title3)
                      .fontWeight(.semibold)
                      .frame(maxWidth: .infinity, alignment: .center)

                  Divider()

                  VStack(alignment: .leading, spacing: 10) {
                      Text("Existing Reactive Power:")
                          .font(.subheadline).foregroundColor(.secondary)
                      Text("Q₁ = kVARh / Hours")
                          .font(.system(size: 15, design: .monospaced))

                      Text("Target Reactive Power:")
                          .font(.subheadline).foregroundColor(.secondary)
                      Text("Q₂ = P × tan(φ₂)")
                          .font(.system(size: 15, design: .monospaced))
                      Text("tan(φ) = √(1 / cos²(φ) − 1)")
                          .font(.system(size: 13, design: .monospaced))
                          .foregroundColor(.secondary)

                      Text("Required Compensation:")
                          .font(.subheadline).foregroundColor(.secondary)
                      Text("Qcomp = max(Q₁ − Q₂, 0)")
                          .font(.system(size: 15, design: .monospaced))
                  }

                  Divider()

                  Button(action: { withAnimation { infoDialogIsPresented = false } }) {
                      Text("OK")
                          .fontWeight(.semibold)
                          .foregroundColor(.white)
                          .frame(maxWidth: .infinity)
                          .padding(.vertical, 10)
                          .background(Color.red)
                          .cornerRadius(10)
                  }
                  .buttonStyle(PlainButtonStyle())
              }
              .padding(24)
              .background(.regularMaterial)
              .cornerRadius(20)
              .shadow(radius: 20)
              .padding(.horizontal, 28)
              .transition(.opacity.combined(with: .scale(scale: 0.95)))
          }
        }
        .animation(.easeInOut(duration: 0.2), value: infoDialogIsPresented)
    }
    
    // MARK: Functions
    // Calculation Logic
    func calculateCapacitorSize() {
        guard let p = Double(activePower),
              let kvarh = Double(reactiveEnergy),
              let hours = Double(operatingHours),
              targetPowerFactor > 0, targetPowerFactor < 1 else {
            calculationError = "Invalid input. Please check your values."
            requiredCapacitor = ""
            return
        }
        calculationError = ""

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
        calculationError = ""
        
    }
}

// Preview
struct CompensationCalcuatorView_Previews: PreviewProvider {
    static var previews: some View {
        CompensationCalcuatorView()
    }
}
