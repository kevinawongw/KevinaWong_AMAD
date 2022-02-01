//
//  SecondViewController.swift
//  Kevina's Cafe
//
//  Created by Kevina Wong on 1/31/22.
//

import UIKit

class SecondViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    
    
    @IBOutlet weak var pickDate: UIDatePicker!
    @IBOutlet weak var itemPicker: UIPickerView!
    
    var menuData = DataLoader()
    var foodCategories = [String]()
    var foodItems = [String]()
    let categoryComponent = 0
    let foodComponent = 1
    let filename = "FoodCategories"
    var date = "soon!"
    
    // https://www.ioscreator.com/tutorials/display-date-date-picker-ios-tutorial
    
    @IBAction func dateChange(_ sender: Any) {
        let dateFormatter = DateFormatter()

            dateFormatter.dateStyle = DateFormatter.Style.short
            dateFormatter.timeStyle = DateFormatter.Style.short
            
            date = dateFormatter.string(from: pickDate.date)
    }
    
    
    @IBAction func orderButton(_ sender: Any) {
        let categoryRow = itemPicker.selectedRow(inComponent: categoryComponent) //gets the selected row for the artist
        let foodRow = itemPicker.selectedRow(inComponent: foodComponent) //gets the selected row for the album
        
        let alert = UIAlertController(title: "Order Placed", message: "Your \(foodItems[foodRow]) will be ready on \(date)", preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                alert.addAction(okAction)
                present(alert, animated: true, completion: nil)
               
    }
    
    

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
        
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == categoryComponent {
            return foodCategories.count
        } else {
            return foodItems.count
        }
    }
        
    //Picker Delegate methods
    //Returns the title for a given row
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == categoryComponent {
            return foodCategories[row]
        } else {
            return foodItems[row]
        }
    }
        
    //Called when a row is selected
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        //checks which component was picked
        if component == categoryComponent {
            foodItems = menuData.getFood(index: row) //gets the albums for the selected artist
            itemPicker.reloadComponent(foodComponent) //reloads the album component
            itemPicker.selectRow(0, inComponent: foodComponent, animated: true) //set the album component back to 0
        }
        let artistrow = pickerView.selectedRow(inComponent: categoryComponent) //gets the selected row for the artist
        let albumrow = pickerView.selectedRow(inComponent: foodComponent) //gets the selected row for the album
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        menuData.loadData(filename: filename)
        foodCategories = menuData.getCategoryName()
        foodItems = menuData.getFood(index: 0)
        pickDate.minimumDate = Date()
    
 
    }
}
        

        /*
        // MARK: - Navigation

        // In a storyboard-based application, you will often want to do a little preparation before navigation
        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            // Get the new view controller using segue.destination.
            // Pass the selected object to the new view controller.
        }
        */
