//
//  recipeDataLoader.swift
//  Bunny Bake
//
//  Created by Kevina Wong on 2/16/22.
//

import Foundation


class RecipeDataLoader{
    
    // Array to hold all data
    var allData = [RecipeData]()
    
    // Load Data
    func loadData(filename: String){
        if let pathURL = Bundle.main.url(forResource: filename, withExtension:  "plist") {
            let plistdecoder = PropertyListDecoder()
            do {
                let data = try Data(contentsOf: pathURL)
                allData = try plistdecoder.decode([RecipeData].self, from: data)
                print("Data Loaded")
            } catch {
                print("Cannot load data")
            }
        }
    }
    
    func getRecipes() -> [String]{
        var recipes = [String]()
        for item in allData {
            recipes.append(item.foodName)
        }
        return recipes
    }
    
    func getIngredients(index: Int) -> Set<String> {
        return Set(allData[index].foodIngredients)
    }
}
