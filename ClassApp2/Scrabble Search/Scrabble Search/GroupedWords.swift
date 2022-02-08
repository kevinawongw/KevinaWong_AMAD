//
//  GroupedWords.swift
//  Scrabble Search
//
//  Created by Kevina Wong on 2/8/22.
//

import Foundation

struct GroupedWords: Decodable {
    let letter: String
    let words: [String]
}
