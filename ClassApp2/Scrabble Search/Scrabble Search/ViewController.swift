//
//  ViewController.swift
//  Scrabble Search
//
//  Created by Kevina Wong on 2/8/22.
//

import UIKit

class ViewController: UITableViewController {
    
    var data2 = DataLoaderGrouped()
    var groupedWords = [GroupedWords]()
    var letters = [String]()
    let wordFile2 = "qwordswithoutu3"

    
    var words = [String]()
    var data = DataLoader()
    let wordFile = "qwordswithoutu1"
    var searchController = UISearchController()

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        data.loadData(fileName: wordFile)
        words = data.getWords()
        data2.loadData(fileName: wordFile2)
        groupedWords = data2.getWords()
        letters = data2.getLetters()
        
        
        let resultsController = SearchResultsController()
        resultsController.allwords = groupedWords
        searchController = UISearchController(searchResultsController: resultsController)
        
        searchController.searchBar.placeholder = "Enter word to search"
        searchController.searchBar.sizeToFit()
        tableView.tableHeaderView = searchController.searchBar
        searchController.searchResultsUpdater = resultsController
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groupedWords[section].words.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let section = indexPath.section
        let wordSection = groupedWords[section].words
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "scrabbleCell", for: indexPath)
        
        var cellConfig = cell.defaultContentConfiguration()


        cellConfig.text = wordSection[indexPath.row]
        cellConfig.image = UIImage(named: "scrabble")
        cellConfig.secondaryText = "+\(words[indexPath.row].count) Points!"

        cell.contentConfiguration = cellConfig

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let section = indexPath.section
        let wordSelection = groupedWords[section].words
        
        let alert = UIAlertController(title: "Row Selected", message: "You Selected \(wordSelection[indexPath.row])", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
        tableView.deselectRow(at: indexPath, animated: true)
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return letters.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return letters[section]
    }
    
    override func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return letters
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerview = UITableViewHeaderFooterView()
        var headerConfig = headerview.defaultContentConfiguration()
        headerConfig.textProperties.alignment = .center
        headerConfig.textProperties.font = UIFont(name: "Helvetica", size: 20)!
        headerConfig.text = letters[section]
        headerConfig.image = UIImage(named: "scrabble")
        headerview.contentConfiguration = headerConfig
        return headerview
    }

}

