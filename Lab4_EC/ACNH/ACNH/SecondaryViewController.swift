//
//  SecondaryViewController.swift
//  ACNH
//
//  Created by Kevina Wong
//

import UIKit
import WebKit

class SecondaryViewController: UIViewController, WKNavigationDelegate {

    @IBOutlet weak var webView: WKWebView!
    
    @IBOutlet weak var webActivityIndicator: UIActivityIndicatorView!
    var webpage: String?
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        webView.navigationDelegate = self
        loadWebPage("https://animalcrossing.fandom.com/wiki/Animal_Crossing_Wiki")
    
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let url = webpage {
            loadWebPage(url)
        }
    }
    
    // MARK: Web Page
    
    func loadWebPage(_ urlString: String){
        let myurl = URL(string: urlString)
        let request = URLRequest(url: myurl!)
        webView.load(request)
    }

    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        webActivityIndicator.startAnimating()
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        webActivityIndicator.stopAnimating()
    }
    
}
