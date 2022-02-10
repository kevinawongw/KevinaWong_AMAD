//
//  AddRecipeViewController.swift
//  Recipe Book
//
//  Created by Kevina Wong on 2/9/22.
//

import UIKit

class AddRecipeViewController: UIViewController {

    @IBOutlet weak var recipeTime: UITextField!
    @IBOutlet weak var recipeName: UITextField!
    @IBOutlet weak var recipeIng1: UITextField!

    @IBOutlet weak var recipeIng2: UITextField!

    @IBOutlet weak var recipeIng3: UITextField!
    
    var addedRecipe = String()
    var addedTime = String()
    var ing1 = String()
    var ing2 = String()
    var ing3 = String()
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "doneSegue"{
            if recipeName.text?.isEmpty == false {
                addedRecipe = recipeName.text!
                addedTime = recipeTime.text!
                ing1 = recipeIng1.text!
                ing2 = recipeIng2.text!
                ing3 = recipeIng3.text!
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
