//
//  ViewController.swift
//  Scrabble Search
//
//  Created by Kevina Wong on 1/27/22.
//

import UIKit

class ViewController: UITableViewController {

    var words = [String]()
    var data = DataLoader()
    let wordFile = "qwordswithoutu1"
    var searchController = UISearchController
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        data.loadData(fileName: wordFile)
        words = data.getWords()
        // Do any additional setup after loading the view.
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return words.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "scrabbleCell", for: indexPath)
        
        var cellConfig = cell.defaultContentConfiguration()
        cellConfig.image = UIImage (named : "scrabble-letter")
        cellConfig.text = words[indexPath.row]
        cellConfig.secondaryText = "\(words[indexPath.row].count) Points!"
        cell.contentConfiguration = cellConfig
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let alert = UIAlertController(title: "Row Selected", message: "You selected  \(words[indexPath.row])", preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                alert.addAction(okAction)
                present(alert, animated: true, completion: nil)
                tableView.deselectRow(at: indexPath, animated: true) //deselects the row that had been choosen
    }
}

