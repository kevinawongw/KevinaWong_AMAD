//
//  AddBookViewController.swift
//  Firebase Library
//
//  Created by Kevina Wong on 3/14/22.
//

import UIKit

class AddBookViewController: UIViewController {

    @IBOutlet weak var bookReviewTextField: UITextField!
    @IBOutlet weak var bookRatingSlider: UISlider!
    @IBOutlet weak var bookTitleTextField: UITextField!
    @IBOutlet weak var bookReviewRatingNumber: UILabel!
    
    var addedBookTitle = String()
    var addedBookRating = 0
    var addedBookReview = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bookRatingSlider.setThumbImage(UIImage(named: "star"), for: UIControl.State.normal)
        bookReviewRatingNumber.text = String(Int(bookRatingSlider.value))
        
        bookRatingSlider.sizeToFit()
        bookReviewTextField.sizeToFit()
        bookTitleTextField.sizeToFit()
    }
    
    @IBAction func ratingChanged(_ sender: UISlider) {
        let sliderAsInt = Int(bookRatingSlider.value)
        bookReviewRatingNumber.text = String(sliderAsInt)
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "saveSegue"{
            if bookTitleTextField.text?.isEmpty == false {
                addedBookTitle = bookTitleTextField.text!
                addedBookRating = Int(bookRatingSlider.value)
                
                if bookReviewTextField.text?.isEmpty == false {
                    addedBookReview = bookReviewTextField.text!
                }
                else{
                    addedBookReview = "No Additional Comments"
                }
                
                print("Adding \(addedBookTitle)...")
            }
        }
    }
    

}
