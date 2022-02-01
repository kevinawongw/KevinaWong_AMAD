//
//  FoodCategory.swift
//  Kevina's Cafe
//
//  Created by Kevina Wong on 1/31/22.
//

import Foundation


struct Food: Decodable {
    let category : String
    let foodItems: [String]
}
