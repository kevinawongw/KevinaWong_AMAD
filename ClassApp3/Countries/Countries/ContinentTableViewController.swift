//
//  ContinentTableViewController.swift
//  Countries
//
//  Created by Kevina Wong on 2/1/22.
//

import UIKit

class ContinentTableViewController: UITableViewController {

    var continentList = [String]()
    var continentsData = ContinentsDataLoader()
    let dataFile = "continents"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        continentsData.loadData(filename: dataFile)
        continentList = continentsData.getContinents()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
//         self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            if segue.identifier == "countrysegue" {
                if let countryVC = segue.destination as? CountryTableViewController {
                    if let indexPath = tableView.indexPath(for: (sender as? UITableViewCell)!) {
                        //sets the data for the destination controller
                        countryVC.title = continentList[indexPath.row]
                        countryVC.continentsData = continentsData
                        countryVC.selectedContinent = indexPath.row
                    }
                }
            } //for detail disclosure
            else if segue.identifier == "continentSegue"{
                if let infoVC = segue.destination as? ContinentInfoTableViewController {
                    if let editingCell = sender as? UITableViewCell {
                        let indexPath = tableView.indexPath(for: editingCell)
                        infoVC.name = continentList[indexPath!.row]
                        let countryList = continentsData.getCountries(index: (indexPath?.row)!)
                        infoVC.number = String(countryList.count)
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
        return continentList.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "continentCell", for: indexPath)

        // Configure the cell...
        var cellConfig = cell.defaultContentConfiguration()
        cellConfig.text = continentList[indexPath.row]
        cell.contentConfiguration = cellConfig
        return cell
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
