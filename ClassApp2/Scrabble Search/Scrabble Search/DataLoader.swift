//
//  DataLoader.swift
//  Scrabble Search
//
//  Created by Kevina Wong on 2/8/22.
//

import Foundation


class DataLoader {
    
    // Array to hold words that we read in
    var qNoUWords = [String]()
    
    // Function to read data
    func loadData(fileName: String){
        
        // Only runs if fileName isn't nil
        if let pathURL = Bundle.main.url(forResource: fileName, withExtension: "plist"){
            
            let plistDecoder = PropertyListDecoder()
            do {
                let data = try Data(contentsOf: pathURL)
                qNoUWords = try plistDecoder.decode([String].self, from: data)
            }
            catch {
                print("Error Loading Data :(")
            }
        }
    }
    
    func getWords() -> [String]{
        return qNoUWords
    }
    
    
    
    
}
