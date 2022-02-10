//
//  FoodData.swift
//  Recipe Book
//
//  Created by Kevina Wong on 2/8/22.
//

import Foundation

struct FoodData : Decodable {
    var type: String
    var foods: [Food]
    
    
    func getfoodNames() -> [String]{
        
        var foodNamesInCategory = [String]()
        
        for i in foods{
            foodNamesInCategory.append(i.foodName)
        }
        return foodNamesInCategory
    }
    

}

