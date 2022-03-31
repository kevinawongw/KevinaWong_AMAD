//
//  DataLoader.swift
//  Potter
//
//  Created by Aileen Pierce
//

import Foundation

class DataHandler{
    var allData = [Villager]()
    
    func loadData(filename: String){
        if let pathURL = Bundle.main.url(forResource: filename, withExtension: "plist"){
            //creates a property list decoder object
            let plistdecoder = PropertyListDecoder()
            do {
                let data = try Data(contentsOf: pathURL)
                //decodes the property list
                allData = try plistdecoder.decode([Villager].self, from: data)
            } catch {
                // handle error
                print(error)
            }
        }
    }
    
    func getVillagers() -> [String]{
        var villagers = [String]()
        for villager in allData{
            villagers.append(villager.name)
        }
        return villagers
    }
    
    func getURL(index:Int) -> String {
        return allData[index].url
    }
}
