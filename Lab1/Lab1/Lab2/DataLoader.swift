//
//  DataLoader.swift
//  Lab1
//
//  Created by Kevina Wong on 1/27/22.
//

import Foundation

class DataLoader{
    
    var qNoUWords = [String]()

    func loadData (fileName: String){
        // URL For out plist
        if let pathURL = Bundle.main.url(forResource: fileName, withExtension: "plist"){
            let plistdecoder = PropertyListDecoder()
            do{
                let data = try Data(contentsOf: pathURL)
                // decodes the property list
                qNoUWords = try plistdecoder.decode([String].self, from: data)
            } catch {
                print (error.localizedDescription)
            }
        }
    }

    func getWords() -> [String]{
        return qNoUWords
    }
    
}
