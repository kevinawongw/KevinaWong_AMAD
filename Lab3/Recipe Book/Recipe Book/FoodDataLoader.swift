//
//  FoodDataLoader.swift
//  Recipe Book
//
//  Created by Kevina Wong on 2/8/22.
//

import Foundation


class FoodDataLoader{
    
    var allData = [FoodData]()
    
    func loadData(fileName: String){
        if let pathURL = Bundle.main.url(forResource: fileName, withExtension: "plist"){
            let plistDecoder = PropertyListDecoder()
            do {
                let data = try Data(contentsOf: pathURL)
                allData = try plistDecoder.decode([FoodData].self, from: data)
                print("Loaded \(allData.count) items!")
            }
            catch {
                print("Failed to Load Data :(")
            }
        }
            
    }
    
    func getFoodTypes() -> [String] {
        var foodTypes =  [String]()
        for item in allData{
            foodTypes.append(item.type)
        }
        return foodTypes
    }
    
    func getFood(index:Int) -> [Food]{
        return allData[index].foods
    }
    
    func getAllData() -> [FoodData]{
        return allData
    }
    
    func addFood(index: Int, newName: String, newTime: String){
        var tempTime = newTime
        if newTime == "" {
            tempTime = "5"
        }
        
        allData[index].foods.append(Food(foodName: newName, foodTime: tempTime, foodIngredients: [String](), foodImage: "cooking"))
    }
    
    func deleteFood(index: Int, foodIndex: Int){
        allData[index].foods.remove(at: foodIndex)
    }
}
