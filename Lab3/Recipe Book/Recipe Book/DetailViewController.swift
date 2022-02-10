//
//  DetailViewController.swift
//  Recipe Book
//
//  Created by Kevina Wong on 2/9/22.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var recipeName: UILabel!
    @IBOutlet weak var recipeImage: UIImageView!
    @IBOutlet weak var recipeTime: UILabel!
    @IBOutlet weak var recipeIngredients: UILabel!
    @IBOutlet weak var backgroundView: UIView!
    
    var foodName: String = ""
    var foodImageName: String = ""
    var foodIngredients: [String] = [String]()
    var foodTime: String = ""
    var ingredientsText = "   Ingredients:         \n"
    var count = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        recipeName.backgroundColor = UIColor.white
        recipeName.layer.cornerRadius = 10.0
        recipeName.clipsToBounds = true
        recipeName.text = "   \(foodName)           "
        recipeTime.sizeToFit()
        recipeTime.backgroundColor = UIColor.white
        recipeTime.layer.cornerRadius = 10.0
        
        backgroundView.layer.cornerRadius = 20.0
        
        
        recipeTime.clipsToBounds = true
        recipeTime.text = "  Cook Time: \(foodTime)           "
        recipeTime.sizeToFit()
        
        

        recipeImage.layer.masksToBounds = true
        recipeImage.backgroundColor = UIColor.white
        recipeImage.layer.cornerRadius = 20.0
        recipeImage.image = UIImage(named: foodImageName)
        
        
        for ingredient in foodIngredients {
            
            print (ingredient)
            
            if count < foodIngredients.count - 1 {
                ingredientsText += "   \(ingredient)          \n"
                count += 1
            }
            
            else {
                ingredientsText += "   \(ingredient)          "
            }
        }
        
        recipeIngredients.backgroundColor = UIColor.white
        recipeIngredients.layer.cornerRadius = 15.0
        recipeIngredients.clipsToBounds = true
        recipeIngredients.text = ingredientsText
        recipeIngredients.sizeToFit()
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
