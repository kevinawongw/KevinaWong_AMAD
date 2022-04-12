//
//  Assignment.swift
//  Assignments
//
//  Created by Kevina Wong on 4/7/22.
//

import Foundation

class Assignment: Encodable, Decodable {
    var title: String!
    var note: String!
    
    init (title: String, note: String){
        self.title = title
        self.note = note
    }
}
