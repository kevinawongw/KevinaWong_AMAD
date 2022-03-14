//
//  Grocery.swift
//  Grocery Realm
//
//  Created by Kevina Wong on 3/1/22.
//

import Foundation
import RealmSwift

class Grocery: Object {
    @Persisted (primaryKey: true) var _id = ObjectId.generate()
    // Same as @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var name = ""
    @Persisted var bought = false
}
