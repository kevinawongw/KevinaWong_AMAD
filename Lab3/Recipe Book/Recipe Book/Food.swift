//
//  Food.swift
//  Recipe Book
//
//  Created by Kevina Wong on 2/8/22.
//

import Foundation

struct Food : Decodable{
    var foodName: String
    var foodTime: String
    var foodIngredients: [String]
    var foodImage: String
    
    
}
