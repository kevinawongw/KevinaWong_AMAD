//
//  DataLoader.swift
//  music
//
//  Created by Aileen Pierce
//

import Foundation

class DataLoader {
    
    // Array to hold all data
    var allData = [Food]()
    
    // Load Data
    func loadData(filename: String){
        if let pathURL = Bundle.main.url(forResource: filename, withExtension:  "plist") {
            let plistdecoder = PropertyListDecoder()
            do {
                let data = try Data(contentsOf: pathURL)
                allData = try plistdecoder.decode([Food].self, from: data)
            } catch {
                print("Cannot load data")
            }
        }
    }
    
    func getCategoryName() -> [String]{
        var categoryNames = [String]()
        for categoryName in allData {
            categoryNames.append(categoryName.category)
        }
        return categoryNames
    }
    
    func getFood(index: Int) -> [String] {
        return allData[index].foodItems
    }
}
