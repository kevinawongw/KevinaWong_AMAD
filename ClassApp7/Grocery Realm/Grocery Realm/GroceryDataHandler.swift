//
//  GroceryDataHandler.swift
//  Grocery Realm
//
//  Created by Kevina Wong on 3/1/22.
//

import Foundation
import RealmSwift

class GroceryDataHandler {
    
    // Declaration of Database
    var myRealm: Realm!
    
    // Collection of Objects
    var groceryData: Results<Grocery>
    
    {
        // Query objects within realm database
        get {
            return myRealm.objects(Grocery.self)
        }
    }
    
    func dbSetup(){
        
        // Initialize the Realm Database
        do{
            myRealm = try Realm()
        } catch let error {
            print(error.localizedDescription)
        }
        
        // Prints the path of the database
        print(Realm.Configuration.defaultConfiguration.fileURL!)
    }
    
    // ** ADD ITEM ** //
    
    func addItem(newItem: Grocery){
        do {
            try myRealm.write({
                myRealm.add(newItem)
            })
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    // ** BOUGHT ITEM ** //
    
    func boughtItem(item:Grocery){
        do {
            try myRealm.write({
                item.bought = !item.bought
            })
        } catch let error{
            print(error.localizedDescription)
        }
    }
          
    // ** DELETE ITEM ** //
    
    func deleteItem(item: Grocery){
        do {
            try myRealm.write({
                myRealm.delete(item)
            })
        } catch let error {
            print (error.localizedDescription)
        }
    }
    
    // Returns an array of groceries
    
    func getGrogeries() -> [Grocery]{
        return Array(groceryData)
    }
    
}
