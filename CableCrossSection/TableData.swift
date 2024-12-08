//
//  TableData.swift
//  CableCrossSection
//
//  Created by Ahmed Halilovic on 22. 11. 2024..
//

import Foundation

struct CableSize {
    let crossSection: String
}

struct DataVariables: Identifiable, Equatable {
    let id = UUID()
    let crossSection: String
    let maxCurrentCu: String
    let fuseForCu: String
    let maxCurrentAl: String
    let fuseForAl: String
}

struct CableLoadData {
    
    static let crossSection: [CableSize] = [
        CableSize(crossSection: "0,75"),
        CableSize(crossSection: "1"),
        CableSize(crossSection: "1,5"),
        CableSize(crossSection: "2,5"),
        CableSize(crossSection: "4"),
        CableSize(crossSection: "6"),
        CableSize(crossSection: "10"),
        CableSize(crossSection: "16"),
        CableSize(crossSection: "25"),
        CableSize(crossSection: "35"),
        CableSize(crossSection: "50"),
        CableSize(crossSection: "70"),
        CableSize(crossSection: "95"),
        CableSize(crossSection: "120"),
        CableSize(crossSection: "150"),
        CableSize(crossSection: "185"),
        CableSize(crossSection: "240"),
        CableSize(crossSection: "300")
    ]
    
    static let cableData: [DataVariables] = [
        DataVariables(crossSection: "0,75", maxCurrentCu: "12", fuseForCu: "6", maxCurrentAl: "", fuseForAl: ""),
        DataVariables(crossSection: "1", maxCurrentCu: "15", fuseForCu: "10", maxCurrentAl: "", fuseForAl: ""),
        DataVariables(crossSection: "1,5", maxCurrentCu: "18", fuseForCu: "10", maxCurrentAl: "", fuseForAl: ""),
        DataVariables(crossSection: "2,5", maxCurrentCu: "26", fuseForCu: "20", maxCurrentAl: "20", fuseForAl: "16"),
        DataVariables(crossSection: "4", maxCurrentCu: "34", fuseForCu: "25", maxCurrentAl: "27", fuseForAl: "20"),
        DataVariables(crossSection: "6", maxCurrentCu: "44", fuseForCu: "35", maxCurrentAl: "35", fuseForAl: "25"),
        DataVariables(crossSection: "10", maxCurrentCu: "61", fuseForCu: "50", maxCurrentAl: "48", fuseForAl: "35"),
        DataVariables(crossSection: "16", maxCurrentCu: "82", fuseForCu: "63", maxCurrentAl: "64", fuseForAl: "50"),
        DataVariables(crossSection: "25", maxCurrentCu: "108", fuseForCu: "80", maxCurrentAl: "85", fuseForAl: "63"),
        DataVariables(crossSection: "35", maxCurrentCu: "135", fuseForCu: "100", maxCurrentAl: "105", fuseForAl: "80"),
        DataVariables(crossSection: "50", maxCurrentCu: "168", fuseForCu: "125", maxCurrentAl: "132", fuseForAl: "100"),
        DataVariables(crossSection: "70", maxCurrentCu: "207", fuseForCu: "160", maxCurrentAl: "163", fuseForAl: "125"),
        DataVariables(crossSection: "95", maxCurrentCu: "250", fuseForCu: "200", maxCurrentAl: "197", fuseForAl: "160"),
        DataVariables(crossSection: "120", maxCurrentCu: "292", fuseForCu: "250", maxCurrentAl: "230", fuseForAl: "200"),
        DataVariables(crossSection: "150", maxCurrentCu: "335", fuseForCu: "250", maxCurrentAl: "263", fuseForAl: "200"),
        DataVariables(crossSection: "185", maxCurrentCu: "382", fuseForCu: "315", maxCurrentAl: "301", fuseForAl: "250"),
        DataVariables(crossSection: "240", maxCurrentCu: "453", fuseForCu: "400", maxCurrentAl: "357", fuseForAl: "315"),
        DataVariables(crossSection: "300", maxCurrentCu: "504", fuseForCu: "400", maxCurrentAl: "409", fuseForAl: "315")
    ]
}



/*
 
 // Use for importing data from JSON file
 
import Foundation

struct CableItem: Codable {
    let crossSection: String
    let resistance: Double
}

struct CableDataModel: Codable {
    let copper: [CableItem]
    let aluminum: [CableItem]
}

class CableDataLoader {
    static func loadCableData() -> CableDataModel? {
        guard let url = Bundle.main.url(forResource: "CableData", withExtension: "json"),
              let data = try? Data(contentsOf: url) else { return nil }
        return try? JSONDecoder().decode(CableDataModel.self, from: data)
    }
}
*/
