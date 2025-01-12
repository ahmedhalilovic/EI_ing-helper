//
//  SharedFunctions.swift
//  CableCrossSection
//
//  Created by Ahmed Halilovic on 11. 1. 2025..
//

import Foundation

func findBestOption(for current: Double, options: [DataVariables], keyPath: KeyPath<DataVariables, String>) -> DataVariables? {
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

func findBestBusbarOption(for current: Double, options: [BusbarDataVariables]) -> BusbarDataVariables? {
    guard !options.isEmpty else { return nil }
    
    // Filter options to ensure max current is at least 30% higher than the calculated current
    let validOptions = options.filter { option in
        guard let maxCurrent = Double(option.maxCurrentForBusbar) else { return false }
        return maxCurrent >= current * 1.3
    }
    
    // Sort valid options by proximity to the current
    let sortedOptions = validOptions.sorted {
        guard let current1 = Double($0.maxCurrentForBusbar),
              let current2 = Double($1.maxCurrentForBusbar) else { return false }
        return abs(current1 - current) < abs(current2 - current)
    }
    
    return sortedOptions.first
}
