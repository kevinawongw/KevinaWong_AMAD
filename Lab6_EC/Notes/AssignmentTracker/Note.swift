//
//  Note.swift
//  Notes
//
//  Created by Kevina Wong on 4/7/22.
//

import Foundation

class Note: Encodable, Decodable {
    var title: String!
    var note: String!
    
    init (title: String, note: String){
        self.title = title
        self.note = note
    }
}
