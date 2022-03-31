//
//  PrimaryTableViewController.swift
//  ACNH
//
//  Created by Kevina Wong
//

import UIKit

class PrimaryTableViewController: UITableViewController {
    
    var villagers = [String]()
    var villagerData = DataHandler()
    let dataFile = "ACNHCharacters"

    override func viewDidLoad() {
        super.viewDidLoad()
        
        villagerData.loadData(filename: dataFile)
        villagers = villagerData.getVillagers()
        navigationController?.navigationBar.prefersLargeTitles = true
        
    }

    // MARK: - Table View

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return villagers.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.backgroundColor = UIColor(named: "beige")
        var cellConfig = cell.defaultContentConfiguration()
        cellConfig.text = villagers[indexPath.row]
        cellConfig.textProperties.font = UIFont(name: "FinkHeavy", size: 16.0)!
        cellConfig.textProperties.color = UIColor.brown
        cell.contentConfiguration = cellConfig
        return cell
    }

    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detailsegue" {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let url = villagerData.getURL(index: indexPath.row)
                let name = villagers[indexPath.row]
                let detailVC = (segue.destination as! UINavigationController).topViewController as! SecondaryViewController
                detailVC.webpage = url
                detailVC.title = name
            }
        }
    }

}
