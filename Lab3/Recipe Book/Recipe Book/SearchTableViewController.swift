//
//  SearchTableViewController.swift
//  Recipe Book
//
//  Created by Kevina Wong on 2/9/22.
//

import UIKit

class SearchTableViewController: UITableViewController, UISearchResultsUpdating {
    
    var allRecipes = [FoodData]()
    var filteredFoodList = [Food]()
    

    func updateSearchResults(for searchController: UISearchController) {
        
        let searchString = searchController.searchBar.text
        
        filteredFoodList.removeAll(keepingCapacity: true)
        
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
                        filteredFoodList.append(i)
                    }
                }
            }
        }
        tableView.reloadData()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "foodCell")
        tableView.delegate = self
        tableView.backgroundColor = UIColor(named: "myGreen")
        tableView.tintColor = UIColor(named:"myGreen")
    }
    

    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return filteredFoodList.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "foodCell", for: indexPath)
        var cellConfig = cell.defaultContentConfiguration()
        cellConfig.text = filteredFoodList[indexPath.row].foodName
        cellConfig.textProperties.font = UIFont(name: "FredokaOne-Regular", size: 12.0) ?? UIFont(name: "Helvetica", size: 20.0)!
        cellConfig.textProperties.color = UIColor.darkGray
        cell.contentConfiguration = cellConfig

        return cell
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Search"
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        let story = UIStoryboard(name: "Main", bundle: nil)
        let detailVC = story.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
        
        detailVC.foodName = filteredFoodList[indexPath.row].foodName
        detailVC.foodIngredients = filteredFoodList[indexPath.row].foodIngredients
        detailVC.foodTime = filteredFoodList[indexPath.row].foodTime
        detailVC.foodImageName = filteredFoodList[indexPath.row].foodImage

        
        detailVC.modalPresentationStyle = .popover
        present(detailVC, animated: true, completion: {print("Done!")})
        print("running here")
        tableView.deselectRow(at: indexPath, animated: true)
        
        }
        
}
