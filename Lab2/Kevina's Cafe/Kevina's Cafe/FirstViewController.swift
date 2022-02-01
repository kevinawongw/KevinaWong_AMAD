//
//  ViewController.swift
//  Kevina's Cafe
//
//  Created by Kevina Wong on 1/31/22.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func instagramButton(_ sender: Any) {
        
    let instagram = URL(string: "instagram://app")!
    
    if(UIApplication.shared.canOpenURL(instagram)){
        //open the app with this URL scheme
        UIApplication.shared.open(instagram, options: [:], completionHandler: nil)
        
    }
    else {
        
        UIApplication.shared.open(URL(string: "https://www.instagram.com/sondercoffee/?hl=en")!, options: [:], completionHandler: nil)
        }
    }
}
