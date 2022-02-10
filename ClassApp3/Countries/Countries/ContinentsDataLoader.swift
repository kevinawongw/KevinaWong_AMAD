//
//  ContinentsDataLoader.swift
//  Countries
//
//  Created by Kevina Wong on 2/1/22.
//

import Foundation

class ContinentsDataLoader{
    
    // Array to hold all data
    var allData = [ContinentsData]()
    
    // Load Data
    func loadData(filename: String){
        if let pathURL = Bundle.main.url(forResource: filename, withExtension:  "plist") {
            let plistdecoder = PropertyListDecoder()
            do {
                let data = try Data(contentsOf: pathURL)
                allData = try plistdecoder.decode([ContinentsData].self, from: data)
                print("Data Loaded")
            } catch {
                print("Cannot load data")
            }
        }
    }
    
    func getContinents() -> [String]{
        var continents = [String]()
        for item in allData {
            continents.append(item.continent)
        }
        return continents
    }
    
    func getCountries(index: Int) -> [String] {
        return allData[index].countries
    }
    
    
    // Helper methods to add and delete countries
    // NOT modifying the plist
    
    func addCountry(index: Int, newCountry: String, newIndex: Int){
        allData[index].countries.insert(newCountry, at: newIndex)
    }
    
    func deleteCountry(index: Int, countryIndex: Int){
        allData[index].countries.remove(at: countryIndex)
    }
    
}
