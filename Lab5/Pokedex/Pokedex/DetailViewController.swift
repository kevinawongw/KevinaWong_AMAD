//
//  DetailViewController.swift
//  Pokedex
//
//  Created by Kevina Wong on 2/28/22.
//

import UIKit

class DetailViewController: UIViewController {
    
    // MARK: Variables and Outlets
    
    @IBOutlet weak var stackView: UIStackView!
    var index: Int?
    var pokemonDataHandler = PokemonDataHandler()
    
    @IBOutlet weak var pokemonNameLabel: UILabel!
    @IBOutlet weak var pokemonNumberLabel: UILabel!
    @IBOutlet weak var pokemonImage: UIImageView!
    @IBOutlet weak var pokemonTypes: UILabel!
    @IBOutlet weak var pokemonTypes2: UILabel!
    @IBOutlet weak var borderView: UIView!
    // MARK: Setup
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pokemonNameLabel.text = format(myString: pokemonDataHandler.allPokemonData.pokemonInfo[index!].name)
        pokemonNumberLabel.text = "# \(pokemonDataHandler.allPokemonData.pokemonInfo[index!].id)"
        
        let url = URL(string: pokemonDataHandler.allPokemonData.pokemonInfo[index!].sprites.front_default)
        let data = try? Data(contentsOf: url!)

        if let imageData = data {
            let image = UIImage(data: imageData)
            pokemonImage.image = image
            pokemonImage.sizeToFit()
        }
        
        let formattedType = format(myString: pokemonDataHandler.allPokemonData.pokemonInfo[index!].types[0].type.name)
        pokemonTypes.text = "Type 1: \(formattedType)"
        
        if (pokemonDataHandler.allPokemonData.pokemonInfo[index!].types.count > 1){
            
            let formattedType2 = format(myString: pokemonDataHandler.allPokemonData.pokemonInfo[index!].types[1].type.name)
            pokemonTypes2.text = "Type 2: \(formattedType2)"
        }
        else{
            pokemonTypes2.text = "Type 2: N/A"
        }
        
        pokemonNameLabel.sizeToFit()
        pokemonNumberLabel.sizeToFit()
        pokemonTypes.sizeToFit()
        pokemonTypes2.sizeToFit()
        stackView.layer.cornerRadius = 20
        borderView.layer.cornerRadius = 20
        borderView.layer.borderColor = UIColor(red: 80.0/255.0, green: 50.0/255.0, blue: 20.0/255.0, alpha: 0.8).cgColor
        borderView.layer.borderWidth = 4.0
    }
    
    
    // MARK: Helper Functions
    
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

    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
