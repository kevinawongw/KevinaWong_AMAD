//
//  ViewController.swift
//  FunCocktails
//
//  Created by Kevina Wong on 2/24/22.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    // MARK: Outlets & Variables
    
    @IBOutlet weak var pokemonTableView: UITableView!
    @IBOutlet weak var pokemonImage: UIImageView!
    var pokemon = [PokemonData]()
    var pokemonDataHandler = PokemonDataHandler()
    var pokemonName: String = ""
    var url = ""
    
    
    // MARK: Load Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        pokemonImage.sizeToFit()
//        pokemonTableView.sizeToFit()
        getAPIData()
    }
    
    // MARK: Data Passing
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detailSegue"{
            if let detailVC = segue.destination as? DetailViewController {
                if let indexPath = pokemonTableView.indexPath(for: (sender as? UITableViewCell)!){
                    detailVC.pokemonDataHandler = pokemonDataHandler
                    detailVC.index = indexPath.row

                }
//
                }
            }
        }
    

    // MARK: Helper Functions
//    func loadTestData(){
//        let pokemon1 = Pokemon(number: "001", name: "Bulbasaur", type: ["Grass", "Poison"] , weakness: ["Fire", "Flying", "Psychic", "Ice"])
//
//        let pokemon2 = Pokemon(number: "002", name: "Ivysaur", type: ["Grass", "Poison"] , weakness: ["Fire", "Flying", "Psychic", "Ice"])
//
//        let pokemon3 = Pokemon(number: "003", name: "Venusaur", type: ["Grass", "Poison"] , weakness: ["Fire", "Flying", "Psychic", "Ice"])
//
//        pokemon.append(pokemon1)
//        pokemon.append(pokemon2)
//        pokemon.append(pokemon3)
//    }
    
    func getAPIData(){
        Task{
            await pokemonDataHandler.loadJSON()
            pokemon = pokemonDataHandler.getPokemon()
            pokemonTableView.reloadData()
            print("Loading \(pokemon.count) Pokemon into the table")
            
        }
    }
    
    
    func getPokemonAPIData(myurl: String){
        Task{
            await pokemonDataHandler.loadPokemonData(url: myurl)
            pokemonTableView.reloadData()
            print("Loading \(pokemonDataHandler.allPokemonData.pokemonInfo.count) Pokemon Details into the table")
        }
    }
    

    func format(myString:String) -> String {
        var returnString = ""
        var first = true;

        for letter in myString{
            if first == true{
                returnString += String(letter.uppercased())
                first = false
            }
            else{
                returnString += String(letter.lowercased())
            }
        }

        return returnString
    }
    
    // MARK: Table View Setup

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        pokemon.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "pokemonCell", for: indexPath)
        cell.layer.cornerRadius = 10
        cell.layer.masksToBounds = true
        tableView.layer.cornerRadius = 10
        tableView.layer.masksToBounds = true
        
        var cellConfig = cell.defaultContentConfiguration()
        
        cellConfig.text = format(myString: pokemon[indexPath.row].name)
        
        cellConfig.textProperties.font = UIFont(name: "PressStart2P-Regular", size: 11.0) ?? UIFont(name: "Helvetica", size: 20.0)!
        
        cellConfig.textProperties.color = UIColor.systemBrown
        

        cell.contentConfiguration = cellConfig
        return cell
        
        
    }
    
    private func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) async {
        url = pokemon[indexPath.row].url
    }

}

