//
//  LibraryTableViewController.swift
//  Firebase Library
//
//  Created by Kevina Wong on 3/14/22.
//

import UIKit
import UIKit
import FirebaseAuthUI
import FirebaseGoogleAuthUI



class LibraryTableViewController: UITableViewController, FUIAuthDelegate {
    
    var books = [Book]()
    var booksDataHandler = BookDataHandler()
    var isLoggedIn: Bool?
    var authUI: FUIAuth!
    var otherTab: LibraryTableViewController?
        
    @IBOutlet weak var loginButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        authUI = FUIAuth.defaultAuthUI()
        authUI?.delegate = self
        
        
        if isUserSignedIn(){
            isLoggedIn = true
            loginButton.title = "Logout"
        }
        else {
            isLoggedIn = false
            loginButton.title = "Login"
        }
        getData()
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
            print("is Logged in? \(isLoggedIn)" )
            if isLoggedIn!{
                if let bookID = books[indexPath.row].id {
                    booksDataHandler.deleteRecipe(bookID: bookID)
                    getData()
                }
             }
            else {
                let alert=UIAlertController(title: "Login", message: "Please log in to make changes.", preferredStyle: UIAlertController.Style.alert)
                        
                //create a UIAlertAction object for the button
                let okAction=UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
                alert.addAction(okAction)
                self.present(alert, animated: true, completion: nil)
            }
            
        }
    }
    
    // MARK: - Navigation

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
            if isLoggedIn!{
                let source = segue.source as! AddBookViewController
                if source.addedBookTitle.isEmpty == false{
                    booksDataHandler.addBookReview(bookTitle: source.addedBookTitle, starReview: source.addedBookRating, bookReview: source.addedBookReview)
                    getData()
                    tableView.reloadData()
                }
            }
        }
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String,
    sender: Any?) -> Bool {
        if identifier == "addBook" {
            if isLoggedIn!{
                return true
            }
            else {
                let alert=UIAlertController(title: "Login", message: "Please log in to make changes.", preferredStyle: UIAlertController.Style.alert)
                        
                //create a UIAlertAction object for the button
                let okAction=UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
                alert.addAction(okAction)
                self.present(alert, animated: true, completion: nil)
                return false
            }
        }
        else {
            return true
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
    
    // MARK: Authentication
    
    @IBAction func login(_ sender: Any) {
        if isUserSignedIn(){
            logout()
            loginButton.title = "Login"
            isLoggedIn = false
        }
        else{
            login()
            loginButton.title = "Logout"
            isLoggedIn = true
        }
    }

    func isUserSignedIn() -> Bool{
        guard authUI?.auth?.currentUser == nil else {
            return true
        }
        return false
    }
    

    
    func authUI(_ authUI: FUIAuth, didSignInWith user: User?, error: Error?) {
         // handle user and error as necessary
         guard let authUser = user else { return }
         //create a UIAlertController object
             let alert=UIAlertController(title: "Firebase", message: "Welcome to Firebase \(authUser.displayName!)", preferredStyle: UIAlertController.Style.alert)
                     
             //create a UIAlertAction object for the button
             let okAction=UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
             alert.addAction(okAction)
             self.present(alert, animated: true, completion: nil)
         
         guard let authError = error else { return }
      
         let errorCode = UInt((authError as NSError).code)
      
         switch errorCode {
         case FUIAuthErrorCode.userCancelledSignIn.rawValue:
             print("User cancelled sign-in");
             break
      
         default:
             let detailedError = (authError as NSError).userInfo[NSUnderlyingErrorKey] ?? authError
             print("Login error: \((detailedError as! NSError).localizedDescription)");
         }
     }
    
    func login(){
         let providers: [FUIAuthProvider] = [FUIGoogleAuth(authUI: authUI!)]
         authUI?.providers = providers
         if authUI?.auth?.currentUser == nil {
         let authViewController = authUI?.authViewController()
            present(authViewController!, animated: true, completion: nil)
         }
        else {
            let name = authUI?.auth?.currentUser!.displayName
            
            let alert=UIAlertController(title: "Firebase", message: "You're already logged in", preferredStyle:
                                            UIAlertController.Style.alert)

            let okAction=UIAlertAction(title: "OK", style:
            UIAlertAction.Style.default, handler: nil)
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
            print("\(authUI?.auth?.currentUser) is the currently logged in")
         }
    }
    
    func logout() {
        do{
            try authUI?.signOut()
            let alert=UIAlertController(title: "Firebase", message: "You've been logged out of Firebase", preferredStyle: UIAlertController.Style.alert)

            let okAction=UIAlertAction(title: "OK", style:
            UIAlertAction.Style.default, handler: nil)
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
         } catch {
         print("You were not logged out")
         }
        
    }
    
}
