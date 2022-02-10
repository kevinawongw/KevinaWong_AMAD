//
//  ViewController.swift
//  Recipe Book
//
//  Created by Kevina Wong on 2/8/22.
//

import UIKit

class ViewController: UITableViewController {

    
    var foodTypeList = [String]()
    var foodData = FoodDataLoader()
    let file = "recipes"

    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        foodData.loadData(fileName: file)
        foodTypeList = foodData.getFoodTypes()
        

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "recipeSegue"{
            if let recipeVC = segue.destination as? RecipesTableViewController {
                if let indexPath = tableView.indexPath(for: (sender as? UITableViewCell)!){
                    recipeVC.selectedCategory = indexPath.row
                }
            }
        }
    }


    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return foodTypeList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "foodTypeCell", for: indexPath)
        var cellConfig = cell.defaultContentConfiguration()
        cellConfig.text = foodTypeList[indexPath.row]
        cellConfig.textProperties.font = UIFont(name: "FredokaOne-Regular", size: 12.0) ?? UIFont(name: "Helvetica", size: 20.0)!
        cellConfig.textProperties.color = UIColor.darkGray
        cell.contentConfiguration = cellConfig
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Categories"
    }
    


}

