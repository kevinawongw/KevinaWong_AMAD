//
//  GroceryDataHandler.swift
//  Groceries
//
//  Created by Kevina Wong on 2/24/22.
//

import Foundation

class GroceryDataHandler {
    
    var groceryData = [String]()
    
    func dataFileURL(_ filename:String) -> URL? {
            //returns an array of URLs for the document directory in the user's home directory
            let urls = FileManager.default.urls(for:.documentDirectory, in: .userDomainMask)
            //append the file name to the first item in the array which is the document directory
            let url = urls.first?.appendingPathComponent(filename)
            //return the URL of the data file or nil if it does not exist
            return url
        }
    
    func loadData(fileName: String){
           //url of data file
           let fileURL = dataFileURL(fileName)
           //if the data file exists, use it
           if FileManager.default.fileExists(atPath: (fileURL?.path)!){
               do {
                   //creates a data buffer with the contents of the plist
                   let data = try Data(contentsOf: fileURL!)
                   //create an instance of PropertyListDecoder
                   let decoder = PropertyListDecoder()
                   //decode the data using the structure of the Favorite class
                   groceryData = try decoder.decode([String].self, from: data)
               } catch {
                   print("no file")
                   }
           }
           else {
               print("file does not exist")
           }
       }
       
       func saveData(fileName: String){
           //url of data file
           let fileURL = dataFileURL(fileName)
           do {
               //create an instance of PropertyListEncoder
               let encoder = PropertyListEncoder()
               //set format type to xml
               encoder.outputFormat = .xml
               let encodedData = try encoder.encode(groceryData)
               //write encoded data to the file
               try encodedData.write(to: fileURL!)
           } catch {
               print("write error")
           }
       }

       func getGroceryItems() -> [String]{
           return groceryData
       }
       
       func addItem(newItem: String){
           groceryData.append(newItem)
       }
       
       func deleteItem(index: Int){
           groceryData.remove(at: index)
       }
}
