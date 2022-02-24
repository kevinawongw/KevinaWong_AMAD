//
//  GroceriesTableViewController.swift
//  Groceries
//
//  Created by Kevina Wong on 2/24/22.
//

import UIKit

class GroceriesTableViewController: UITableViewController {
    
    var groceries = [String]()
    var groceryData = GroceryDataHandler()
    var dataFile = "grocery.plist"

    @IBAction func addGroceryItem(_ sender: UIBarButtonItem) {
        
        // Alert for new item
        let addAlert = UIAlertController(title: "New Item", message: "Add a new item to the grocery list", preferredStyle: .alert)
        addAlert.addTextField(configurationHandler: {(UITextField) in})
        
        // Cancel Add
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        addAlert.addAction(cancelAction)
        
        // Add item
        let addItemAction = UIAlertAction(title: "Add", style: .default, handler: {(UIAlertAction) in
            
            // Get textfield
            let newItem = addAlert.textFields![0]
            if newItem.text?.isEmpty == false {
                
                // Gets text from textfield
                let newGroceryItem = newItem.text!
                // Adds to our proceries array
                self.groceries.append(newGroceryItem)
                self.groceryData.addItem(newItem: newGroceryItem)
                self.tableView.reloadData()
            }
            
        })
        
        addAlert.addAction(addItemAction)
        present(addAlert, animated: true, completion: nil)
    }
    
    @objc func applicationWillResignActive(_ notification: Notification){
        groceryData.saveData(fileName: dataFile)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        groceryData.loadData(fileName: dataFile)
        groceries = groceryData.getGroceryItems()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.applicationWillResignActive(_:)), name: UIApplication.willResignActiveNotification, object: nil)

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
         self.navigationItem.leftBarButtonItem = self.editButtonItem
        
        
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return groceries.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

        // Configure the cell...
        
        var cellConfig = cell.defaultContentConfiguration()
        cellConfig.text = groceries[indexPath.row]
        cell.contentConfiguration = cellConfig

        return cell
    }
    

    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            groceries.remove(at: indexPath.row)
            groceryData.deleteItem(index: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
