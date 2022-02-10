//
//  RecipesTableViewController.swift
//  Recipe Book
//
//  Created by Kevina Wong on 2/8/22.
//

import UIKit

class RecipesTableViewController: UITableViewController {
    
    var foodTypeList = [String]()
    var foodData = FoodDataLoader()
    var foodList = [Food]()
    var allData = [FoodData]()
    let file = "recipes"
    var selectedCategory = 0
    var searchController = UISearchController()
    
    @IBAction func unwindSegue (_ segue:UIStoryboardSegue){
        
        if segue.identifier == "doneSegue"{
            if let source = segue.source as? AddRecipeViewController{
                if source.addedRecipe.isEmpty == false{
                    foodData.addFood(index: selectedCategory, newName: source.addedRecipe, newTime: source.addedTime)
                    
                    foodList.append(Food(foodName: source.addedRecipe, foodTime: source.addedTime, foodIngredients: [String](), foodImage: "cooking"))
                    tableView.reloadData()
                }
            }
        }
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()


        foodData.loadData(fileName: file)
        allData = foodData.getAllData()
        foodTypeList = foodData.getFoodTypes()
        foodList = foodData.getFood(index: selectedCategory)
        
        let resultsController = SearchTableViewController()
        resultsController.allRecipes = allData
        searchController = UISearchController(searchResultsController: resultsController)
        
        resultsController.tableView?.delegate = self
        
        searchController.searchBar.placeholder = "Enter word to search"
        searchController.searchBar.sizeToFit()
        tableView.tableHeaderView = searchController.searchBar
        searchController.searchResultsUpdater = resultsController
                
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detailSegue" {
            if let detailVC = segue.destination as? DetailViewController {
                if let indexPath = tableView.indexPath(for: (sender as? UITableViewCell)!){
                    detailVC.foodName = foodList[indexPath.row].foodName
                    detailVC.foodIngredients = foodList[indexPath.row].foodIngredients
                    detailVC.foodTime = foodList[indexPath.row].foodTime
                    detailVC.foodImageName = foodList[indexPath.row].foodImage
                }
            }
        }
    }


    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return foodList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        foodList = foodData.getFood(index: selectedCategory)
        let cell = tableView.dequeueReusableCell(withIdentifier: "foodCell", for: indexPath)
        var cellConfig = cell.defaultContentConfiguration()
        cellConfig.text = foodList[indexPath.row].foodName
        cellConfig.textProperties.font = UIFont(name: "FredokaOne-Regular", size: 12.0) ?? UIFont(name: "Helvetica", size: 20.0)!
        cellConfig.textProperties.color = UIColor.darkGray
        cell.contentConfiguration = cellConfig
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Recipes"
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let currentCell = tableView.cellForRow(at: indexPath as IndexPath)!

        performSegue(withIdentifier: "detailSegue", sender: currentCell)
        searchController.isActive = false
    }




    // MARK: - Table view data source

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
           
            foodList.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            
            foodData.deleteFood(index: selectedCategory, foodIndex: indexPath.row)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
        
        tableView.reloadData()
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
