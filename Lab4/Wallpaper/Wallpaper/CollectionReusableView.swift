//
//  CollectionReusableView.swift
//  Collection View
//
//  Created by Kevina Wong on 2/8/22.
//

import UIKit

class CollectionReusableView: UICollectionReusableView {
    
  
    @IBOutlet weak var headerLabel: UILabel!
    
    @IBOutlet weak var footerLabel: UILabel!
    
    @IBAction func instagramButton(_ sender: UIButton) {
        
        let instagram = URL(string: "instagram://user?username=o.ouie.e")!
        
        if(UIApplication.shared.canOpenURL(instagram)){
            //open the app with this URL scheme
            UIApplication.shared.open(instagram, options: [:], completionHandler: nil)
            
        }
        else{
            
            UIApplication.shared.open(URL(string: "https://www.instagram.com/o.ouie.e/")!, options: [:], completionHandler: nil)
            }
        }

}
