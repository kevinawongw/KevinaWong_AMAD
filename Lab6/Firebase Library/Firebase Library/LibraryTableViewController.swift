//
//  LibraryTableViewController.swift
//  Firebase Library
//
//  Created by Kevina Wong on 3/14/22.
//

import UIKit


class LibraryTableViewController: UITableViewController {
    
    var books = [Book]()
    var booksDataHandler = BookDataHandler()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getData()

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
        return books.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        var cellConfig = cell.defaultContentConfiguration()
        cellConfig.text = books[indexPath.row].bookTitle
        cellConfig.secondaryText = "Rating: \(books[indexPath.row].starRating)/5"
        cellConfig.textProperties.font = UIFont(name: "Eczar", size: 17.0)!
        cellConfig.textProperties.color = UIColor.darkGray
        cellConfig.secondaryTextProperties.font = UIFont(name: "Menlo", size: 11.0)!
        
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
            if let bookID = books[indexPath.row].id {
                booksDataHandler.deleteRecipe(bookID: bookID)
                getData()
            }
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

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detailView"{
            if let detailVC = segue.destination as? DetailViewController {
                if let indexPath = tableView.indexPath(for: sender as! UITableViewCell){
                    detailVC.detailTitle = books[indexPath.row].bookTitle
                    detailVC.detailStarRating = books[indexPath.row].starRating
                    detailVC.detailReview = books[indexPath.row].bookReview
                }
            }
        }
    }
    
    
    @IBAction func unwindSegue(segue:UIStoryboardSegue){
        if segue.identifier == "saveSegue" {
            let source = segue.source as! AddBookViewController
            if source.addedBookTitle.isEmpty == false{
                booksDataHandler.addBookReview(bookTitle: source.addedBookTitle, starReview: source.addedBookRating, bookReview: source.addedBookReview)
                getData()
                tableView.reloadData()
            }
        }
    }

    // MARK: - Helper Functions
    
    func getData(){
        Task{
            await booksDataHandler.getFirebaseData()
            books = booksDataHandler.getBooks()
            print("Number of Books Loaded: \(books.count)")
            tableView.reloadData()
        }
    }

}
