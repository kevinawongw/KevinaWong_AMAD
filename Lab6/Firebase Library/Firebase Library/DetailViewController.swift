//
//  DetailViewController.swift
//  Firebase Library
//
//  Created by Kevina Wong on 3/14/22.
//

import UIKit

class DetailViewController: UIViewController {

    var detailTitle: String = ""
    var detailStarRating: Int = -1
    var detailReview: String = ""
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var reviewLabel: UILabel!
    @IBOutlet weak var star1: UIImageView!
    @IBOutlet weak var star2: UIImageView!
    @IBOutlet weak var star3: UIImageView!
    @IBOutlet weak var star4: UIImageView!
    @IBOutlet weak var star5: UIImageView!

    
    override func viewDidLoad() {
        super.viewDidLoad()

        print("Presenting Detail For: \(detailTitle)")
        
        titleLabel.text = detailTitle
        reviewLabel.text = "Review: \"\(detailReview)\""
        titleLabel.sizeToFit()
        reviewLabel.sizeToFit()
        
        star1.image = UIImage(named: "starBad")
        star2.image = UIImage(named: "starBad")
        star3.image = UIImage(named: "starBad")
        star4.image = UIImage(named: "starBad")
        star5.image = UIImage(named: "starBad")

        switch detailStarRating{
            
        case 1:
            star1.image = UIImage(named: "starGood")
        case 2:
            star1.image = UIImage(named: "starGood")
            star2.image = UIImage(named: "starGood")
        case 3:
            star1.image = UIImage(named: "starGood")
            star2.image = UIImage(named: "starGood")
            star3.image = UIImage(named: "starGood")
        case 4:
            star1.image = UIImage(named: "starGood")
            star2.image = UIImage(named: "starGood")
            star3.image = UIImage(named: "starGood")
            star4.image = UIImage(named: "starGood")
        case 5:
            star1.image = UIImage(named: "starGood")
            star2.image = UIImage(named: "starGood")
            star3.image = UIImage(named: "starGood")
            star4.image = UIImage(named: "starGood")
            star5.image = UIImage(named: "starGood")
                
        default:
            print("Bad Review")
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

}
