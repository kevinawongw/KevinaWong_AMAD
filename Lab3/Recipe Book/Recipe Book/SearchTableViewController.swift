//
//  SearchTableViewController.swift
//  Recipe Book
//
//  Created by Kevina Wong on 2/9/22.
//

import UIKit

class SearchTableViewController: UITableViewController, UISearchResultsUpdating {
    
    
    var allRecipes = [FoodData]()
    var keepRecipes = [Food]()
    var filteredRecipes = [String]()
    
    func updateSearchResults(for searchController: UISearchController) {

        let searchString = searchController.searchBar.text
        filteredRecipes.removeAll(keepingCapacity: true)
        
        if searchString?.isEmpty == false {
            let searchFilter: (String) -> Bool = { name in
                let range = name.range(of: searchString!, options: .caseInsensitive)
                return range != nil
            }
            
            for item in allRecipes{
                let recipesForType = item.getfoodNames()
                let matched = recipesForType.filter(searchFilter)
                for i in item.foods{
                    if matched.contains(i.foodName) {
                        keepRecipes.append(i)
                    }
                }
                filteredRecipes.append(contentsOf: matched)
            }
        }
        tableView.reloadData()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "foodCell")
        tableView.backgroundColor = UIColor(named: "myGreen")
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
         self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detailSegue" {
            if let detailVC = segue.destination as? DetailViewController {
                if let indexPath = tableView.indexPath(for: (sender as? UITableViewCell)!){
                    detailVC.foodName = keepRecipes[indexPath.row].foodName
                    detailVC.foodIngredients = keepRecipes[indexPath.row].foodIngredients
                    detailVC.foodTime = keepRecipes[indexPath.row].foodTime
                    detailVC.foodImageName = keepRecipes[indexPath.row].foodImage
                }
            }
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return filteredRecipes.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "foodCell", for: indexPath)
        var cellConfig = cell.defaultContentConfiguration()
        cellConfig.text = filteredRecipes[indexPath.row]
        cellConfig.textProperties.font = UIFont(name: "FredokaOne-Regular", size: 12.0) ?? UIFont(name: "Helvetica", size: 20.0)!
        cellConfig.textProperties.color = UIColor.darkGray
        cell.contentConfiguration = cellConfig
        

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "detailSegue", sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
        
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Search"
    }
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

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
