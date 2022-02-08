//
//  DataLoaderGrouped.swift
//  Scrabble Search
//
//  Created by Kevina Wong on 2/8/22.
//

import Foundation

class DataLoaderGrouped {
    var allData = [GroupedWords]()
    
    func loadData(fileName: String){
        if let pathURL = Bundle.main.url(forResource: fileName, withExtension: "plist"){
            let plistDecoder = PropertyListDecoder()
            do {
                let data = try Data (contentsOf: pathURL)
                allData = try plistDecoder.decode([GroupedWords].self, from: data)
            }
            catch {
                print("Couldn't load data :(")
            }
        }
    }
    
    func getWords() -> [GroupedWords]{
        return allData
    }
    
    func getLetters() -> [String]{
        var letters = [String]()
        for firstLetter in allData{
            letters.append(firstLetter.letter)
        }
        letters.sort(by:{$0 < $1})
        return letters
    }
 
}
