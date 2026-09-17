//
//  CrossSectionView.swift
//  CableCrossSection
//
//  Created by Ahmed Halilovic on 12. 11. 2024..
//

import SwiftUI
import Foundation

struct CrossSectionView: View {
    @FocusState private var isPowerInputFieldFocused: Bool // Focus state for the power input field
    @EnvironmentObject var sharedData: SharedDataModel

    @State private var resultCurrent1Phase: String? = nil
    @State private var resultCurrent3Phase: String? = nil
    @State private var resultRecomendedCableCuCrossSection: String? = nil
    @State private var resultRecomendedCableCuFuse: String? = nil
    @State private var resultRecomendedCableAlCrossSection: String? = nil
    @State private var resultRecomendedCableAlFuse: String? = nil
    @State private var resultRecommendedBusbar: String? = nil

    var body: some View {
        Form {
            Section {
                VStack(spacing: 8) {
                    HStack(spacing: 20) {
                        Group {
                            InputField(title: "Power [kW]", placeholder: "[kW]", text: $sharedData.powerKW, keyboardType: .decimalPad)
                                .focused($isPowerInputFieldFocused)
                                .frame(minWidth: 180, maxWidth: .infinity)
                                .keyboardToolbar()
                            HStack {
                                Text("Pf")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                                Picker("Power factor (cos φ)",
                                       selection: $sharedData.powerFactor) {
                                    ForEach(80...100, id: \.self) { index in
                                        let value = Double(index) / 100.0
                                        Text(String(format: "%.2f", value))
                                            .tag(value)
                                    }
                                }
                                .pickerStyle(WheelPickerStyle())
                                .frame(height: 120)
                                .frame(maxWidth: 140)
                                .onAppear {
                                    if sharedData.powerFactor == 0 {
                                        sharedData.powerFactor = 0.95
                                    }
                                }
                            }
                            .frame(maxWidth: .infinity)
                        }
                    }

                    HStack {
                        Spacer()
                        // Calculate button
                        Button(action: {
                            isPowerInputFieldFocused = false
                            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                            calculateCurrent()
                            sharedData.showBusbarButton = true // Show the busbar button after calculation
                        }) {
                            Text("Calculate")
                                .font(.headline)
                                .padding()
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(8)
                                .shadow(radius: 2)
                        }
                        .buttonStyle(PlainButtonStyle())
                        Spacer()
                    }
                }

            } header: {
                HStack { // Title and the Clear button
                    Text("Input parameters")
                    Button(action: {
                        clearInputs()
                    }) {
                        Image(systemName: "trash.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 20, height: 20)
                            .padding(0)
                    }
                    .frame(maxWidth: .infinity, alignment: .trailing)
                }
            }

            // MARK: Result display
            // (currents, recomended cross-secton and fuses)
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
                            Text("Copper: ")
                                .bold()
                            Spacer()
                            Text("⌀: ")
                            Text(resultRecomendedCableCuCrossSection ?? "-, ")
                                .foregroundColor(.blue)
                            Image(systemName: "bandage")
                                .foregroundColor(.primary)
                                .imageScale(.large)
                            Text(resultRecomendedCableCuFuse ?? ": - A")
                                .foregroundColor(.blue)
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
                            Text("⌀: ")
                            Text(resultRecomendedCableAlCrossSection ?? "-, ")
                                .foregroundColor(.blue)
                            Image(systemName: "bandage")
                                .foregroundColor(.primary)
                                .imageScale(.large)
                            Text(resultRecomendedCableAlFuse ?? ": - A")
                                .foregroundColor(.blue)
                        }
                        .padding()
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(8)
                    }
                }

            } header: {
                HStack {
                    Text("Result")

                    Spacer()

                    Button(action: {
                        sharedData.showBusbarSheet = true // Show the sheet when the button is pressed
                    }) {
                        HStack {
                            VStack {
                                Text("BUSBAR")
                                    .font(.system(size: 12, weight: .semibold))
                                Text("SIZE")
                                    .font(.system(size: 12, weight: .semibold))
                            }
                            HStack {
                                Image(systemName: "pause.fill")
                                    .foregroundColor(Color(red: 0.72, green: 0.45, blue: 0.20, opacity: 0.5))
                                    .font(.system(size: 30))
                                    .background(Color.gray.opacity(0.2))
                            }
                        }
                    }
                    .opacity(sharedData.showBusbarButton ? 1 : 0)
                    .animation(.easeInOut, value: sharedData.showBusbarButton)
                    .transition(.opacity)
                    .sheet(isPresented: $sharedData.showBusbarSheet) { // Display sheet when button is pressed
                        BusbarTableView()
                            .presentationDetents([.medium, .large])
                            .presentationDragIndicator(.visible)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
                .padding(.top, 8)
            }

        }
        .scrollDismissesKeyboard(.interactively)
    }

    // MARK: Calculation logic
    private func calculateCurrent() {
        guard let power = parseDouble(sharedData.powerKW),
              power > 0 else {
            resultCurrent1Phase = "Invalid input."
            resultCurrent3Phase = "Invalid input."
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
            resultRecomendedCableCuCrossSection = "\(copperBest.crossSection) mm2"
            resultRecomendedCableCuFuse = ": \(copperBest.fuseForCu) A"
            sharedData.bestCopperCrossSection = copperBest.crossSection // Use to automatically set the cross-section in Voltage drop tab
        } else {
            resultRecomendedCableCuCrossSection = "No suitable copper cable found."
        }
        // Determine the best fit for aluminum
        if let aluminumBest = findBestOption(for: current3f, options: closestAluminumOptions, keyPath: \.fuseForAl) {
            resultRecomendedCableAlCrossSection = "\(aluminumBest.crossSection) mm2"
            resultRecomendedCableAlFuse = ": \(aluminumBest.fuseForAl) A"
            sharedData.bestAluminumCrossSection = aluminumBest.crossSection // Use to automatically set the cross-section in Voltage drop tab
        } else {
            resultRecomendedCableAlCrossSection = "No suitable aluminum cable found."
        }

        // Update the best suited crosssection and fuses in Table Tab
        sharedData.selectedCopperRow = findBestOption(for: current3f, options: closestCopperOptions, keyPath: \.fuseForCu)
        sharedData.selectedAluminumRow = findBestOption(for: current3f, options: closestAluminumOptions, keyPath: \.fuseForAl)

        // Calculate the best busbar option
        let busbarOptions = BusbarLoadData.busbarData.filter {
            (Double($0.maxCurrentForBusbar) ?? 0) >= current3f
        }

        if let bestBusbar = findBestBusbarOption(for: current3f, options: busbarOptions) {
            resultRecommendedBusbar = "Size: \(bestBusbar.size), Stacked: \(bestBusbar.stacked), Max Current: \(bestBusbar.maxCurrentForBusbar) A"
            sharedData.bestSuitableBusbar = bestBusbar.maxCurrentForBusbar
        } else {
            resultRecommendedBusbar = "No suitable busbar found."
            sharedData.bestSuitableBusbar = "-"
        }

        // Update SharedData for the Busbar Tab
        sharedData.selectedBusbarRow = findBestBusbarOption(for: current3f, options: busbarOptions)

        sharedData.isManualEntryCrossSection = false // Reset to false when current is calculated again
    }

    // Clear Function to clear all data inputs and results
    private func clearInputs() {
        sharedData.powerKW = ""
        sharedData.powerFactor = 0.95
        sharedData.showBusbarButton = false // Hide "BUSBAR SIZE" button
        sharedData.selectedCopperRow = nil
        sharedData.selectedAluminumRow = nil
        sharedData.selectedBusbarRow = nil
        resultCurrent1Phase = nil
        resultCurrent3Phase = nil
        resultRecomendedCableCuCrossSection = nil
        resultRecomendedCableCuFuse = nil
        resultRecomendedCableAlCrossSection = nil
        resultRecomendedCableAlFuse = nil
        resultRecommendedBusbar = nil
    }
}

struct InputField: View {
    let title: LocalizedStringKey
    let placeholder: LocalizedStringKey
    @Binding var text: String
    var keyboardType: UIKeyboardType = .decimalPad

    init(title: LocalizedStringKey, placeholder: LocalizedStringKey? = nil, text: Binding<String>, keyboardType: UIKeyboardType = .decimalPad) {
        self.title = title
        self.placeholder = placeholder ?? title
        self._text = text
        self.keyboardType = keyboardType
    }

    var body: some View {
        HStack {
            Text(title)
                .font(.subheadline)
                .foregroundColor(.gray)
            TextField(placeholder, text: $text)
                .keyboardType(keyboardType)
                .onChange(of: text) { newValue in
                    let separator = Locale.current.decimalSeparator ?? "."
                    var filtered = newValue.filter { $0.isNumber || String($0) == separator }
                    // Ensure only a single decimal separator
                    if filtered.components(separatedBy: separator).count > 2 {
                        var parts = filtered.components(separatedBy: separator)
                        let first = parts.removeFirst()
                        filtered = first + separator + parts.joined().replacingOccurrences(of: separator, with: "")
                    }
                    // Prevent leading separator like "." -> "0." for better parsing later
                    if filtered == separator { filtered = "0" + separator }
                    if filtered != newValue { text = filtered }
                }
                .multilineTextAlignment(.center)
                .padding(.vertical, 14)
                .padding(.horizontal, 8)
                .background(Color(.systemBackground))
                .cornerRadius(8)
                .shadow(radius: 3)
        }
    }
}

struct CrossSectionView_Previews: PreviewProvider {
    static var previews: some View {
        let model = SharedDataModel()
        return CrossSectionView()
            .environmentObject(model)
    }
}
