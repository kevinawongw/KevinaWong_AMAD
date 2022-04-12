//
//  AssignmentsTableViewController.swift
//  Assignments
//
//  Created by Kevina Wong on 4/7/22.
//

import UIKit

class AssignmentsTableViewController: UITableViewController {
    
    // MARK: Variables
    var assignments = [Assignment]()
    var assignmentDataHandler = AssignmentDataHandler()
    var dataFile = "assignments.plist"
    
    override func viewDidLoad() {
        
        // VIew Did load
        super.viewDidLoad()
        
        // Customization
        self.view.backgroundColor = UIColor(named: "AccentColor")
        
        // Navigation bar
        navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.leftBarButtonItem = self.editButtonItem
        
        // Load Data
        assignmentDataHandler.loadData(fileName: dataFile)
        assignments = assignmentDataHandler.getAssignment()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.applicationWillResignActive(_:)), name: UIApplication.willResignActiveNotification, object: nil)
    }
    
    @objc func applicationWillResignActive(_ notification: Notification){
        assignmentDataHandler.saveData(fileName: dataFile)
    }

    
    // MARK: Connections
    
    @IBAction func addNote(_ sender: Any) {
        let addalert = UIAlertController(title: "New Note", message: "", preferredStyle: .alert)
        
        addalert.view.tintColor = UIColor(named: "appGreen")
        addalert.addTextField(configurationHandler: {(UITextField) in
            UITextField.placeholder = "Assignment Name"
        })
        addalert.addTextField(configurationHandler: {(UITextView) in
            UITextView.placeholder = "Note"
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)

        addalert.addAction(cancelAction)
        let addItemAction = UIAlertAction(title: "Add", style: .default, handler: {(UIAlertAction)in
            let newTitle = addalert.textFields![0]
            let newNote = addalert.textFields![1]
            if ((newTitle.text?.isEmpty == false) && (newNote.text?.isEmpty == false)) {
                let newAssignmentItem = Assignment(title: newTitle.text!, note: newNote.text!)
                self.assignments.append(newAssignmentItem)
                self.tableView.reloadData()
                self.assignmentDataHandler.addAssignment(newAssignment: newAssignmentItem)
            }
        })
        addalert.addAction(addItemAction)
        present(addalert, animated: true, completion: nil)
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return assignments.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.backgroundColor = UIColor.white
        var cellConfig = cell.defaultContentConfiguration()
        cellConfig.textProperties.color = UIColor.darkGray
        cellConfig.textProperties.font = UIFont(name: "PatrickHand-Regular", size: 18.0)!
        cellConfig.text = assignments[indexPath.row].title
        
        cellConfig.secondaryTextProperties.color = UIColor(named: "appGreen")!
        cellConfig.secondaryTextProperties.font = UIFont(name: "PatrickHand-Regular", size: 14.0)!
        cellConfig.secondaryText = assignments[indexPath.row].note
        
        cell.contentConfiguration = cellConfig
        return cell
    }
    
    override func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        if (cell.accessoryType == .none){
            cell.accessoryType = .checkmark
//            tableView.selectRow(at: selectRowat,: indexPath, animated: false, scrollPosition: UITableView.ScrollPositionUITableView.ScrollPosition.bottom)
            
        }
        else {
                cell.accessoryType = .none
            }
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            assignments.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            assignmentDataHandler.deleteNote(index: indexPath.row)
        } else if editingStyle == .insert {

        }
    }
    
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }

}
