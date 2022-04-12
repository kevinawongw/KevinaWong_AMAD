//
//  AssignmentDataHandler.swift
//  Assignments
//
//  Created by Kevina Wong on 4/7/22.
//

import Foundation

class AssignmentDataHandler{
    
    var assignmentData = [Assignment]()
       
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
                   assignmentData = try decoder.decode([Assignment].self, from: data)
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
               let encodedData = try encoder.encode(assignmentData)
               //write encoded data to the file
               try encodedData.write(to: fileURL!)
           } catch {
               print("write error")
           }
       }

       func getAssignment() -> [Assignment]{
           return assignmentData
       }
       
       func addAssignment(newAssignment: Assignment){
           assignmentData.append(newAssignment)
       }
       
       func deleteNote(index: Int){
           assignmentData.remove(at: index)
       }
}
