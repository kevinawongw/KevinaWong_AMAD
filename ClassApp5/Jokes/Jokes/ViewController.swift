//
//  ViewController.swift
//  Jokes
//
//  Created by Kevina Wong on 2/24/22.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var jokes = [Joke]()
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        jokes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "JokeCell", for: indexPath)
        var cellConfig = cell.defaultContentConfiguration()
        cellConfig.text = jokes[indexPath.row].setup
        cell.contentConfiguration = cellConfig
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let alert = UIAlertController(title: jokes[indexPath.row].setup, message: jokes[indexPath.row].delivery, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "Haha", style: .default, handler: nil)
        
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func loadtestdata() {
            let joke1 = Joke(setup: "Bad at golf?", delivery: "Join the club.")
            let joke2 = Joke(setup: "French fries are not made in France.", delivery: "They are actually made in Grease.")
            let joke3 = Joke(setup: "What do you call a really dumb zipper?", delivery: "A zipshit.")

            jokes.append(joke1)
            jokes.append(joke2)
            jokes.append(joke3)
        
            for i in jokes{
                print(i)
            }
            
        }
    

    @IBOutlet weak var jokeTableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        loadtestdata()
    }


}

