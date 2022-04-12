//
//  NotesTableViewController.swift
//  Notes
//
//  Created by Kevina Wong on 4/7/22.
//

import UIKit

class NotesTableViewController: UITableViewController {
    
    // MARK: Variables
    var notes = [Note]()
    var noteDataHandler = NoteDataHandler()
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
        noteDataHandler.loadData(fileName: dataFile)
        notes = noteDataHandler.getNotes()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.applicationWillResignActive(_:)), name: UIApplication.willResignActiveNotification, object: nil)
    }
    
    @objc func applicationWillResignActive(_ notification: Notification){
        noteDataHandler.saveData(fileName: dataFile)
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
                let newNoteItem = Note(title: newTitle.text!, note: newNote.text!)
                self.notes.append(newNoteItem)
                self.tableView.reloadData()
                self.noteDataHandler.addNote(newNote: newNoteItem)
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
        return notes.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.backgroundColor = UIColor.white
        var cellConfig = cell.defaultContentConfiguration()
        cellConfig.textProperties.color = UIColor.darkGray
        cellConfig.textProperties.font = UIFont(name: "PatrickHand-Regular", size: 18.0)!
        cellConfig.text = notes[indexPath.row].title
        
        cellConfig.secondaryTextProperties.color = UIColor(named: "appGreen")!
        cellConfig.secondaryTextProperties.font = UIFont(name: "PatrickHand-Regular", size: 14.0)!
        cellConfig.secondaryText = notes[indexPath.row].note
        
        cell.contentConfiguration = cellConfig
        return cell
    }
    
    override func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            notes.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            noteDataHandler.deleteNote(index: indexPath.row)
        } else if editingStyle == .insert {

        }    
    }
    
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }

}
