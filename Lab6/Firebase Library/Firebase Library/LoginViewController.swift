//
//  LoginViewController.swift
//  Firebase Library
//
//  Created by Kevina Wong on 3/14/22.
//

import UIKit
import FirebaseAuthUI
import FirebaseGoogleAuthUI
import FirebaseFacebookAuthUI
import FirebasePhoneAuthUI
import FirebaseEmailAuthUI

class LoginViewController: UIViewController, FUIAuthDelegate {
    
    var authUI: FUIAuth!
    
    @IBOutlet weak var loginButton: UIButton!
    @IBAction func login(_ sender: Any) {
    
        if isUserSignedIn() == false {
            let providers: [FUIAuthProvider] = [FUIGoogleAuth(authUI: authUI!), FUIPhoneAuth(authUI: authUI)]
            authUI?.providers = providers

            let authViewController = authUI!.authViewController()
            authViewController.navigationBar.isTranslucent = true
            authViewController.navigationBar.tintColor = UIColor.white
            authViewController.navigationBar.barTintColor = UIColor.white
            authViewController.navigationBar.backgroundColor = UIColor.white
           
            present(authViewController, animated: true, completion: nil)
            print("is user signed in? \(isUserSignedIn())")
            if isUserSignedIn() == true {
                print("Success!")
                loginButton.setTitle("Logout", for: .normal)
            }
            else {
                loginButton.setTitle("Login",for: .normal)
            }
        }
        else {
            do {
                try authUI?.signOut()
                let alert = UIAlertController (title: "Logout", message: "You have successfully logged out", preferredStyle: UIAlertController.Style.alert)
                
                let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
                
                alert.addAction(okAction)
                self.present(alert, animated: true, completion: nil)
                loginButton.setTitle("Login",for: .normal)
            } catch {
                loginButton.setTitle("Logout", for: .normal)
                print("Failed Logging out")
            }
        }
    
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()

        authUI = FUIAuth.defaultAuthUI()
        authUI?.delegate = self
    }
    

    func isUserSignedIn() -> Bool{
        guard authUI?.auth?.currentUser == nil else {
            return true
        }
        return false
    }
    
    func authUI(_ authUI: FUIAuth, didSignInWith user: User?, error: Error?) {
         // handle user and error as necessary
         guard let authUser = user else { return }
         //create a UIAlertController object
             let alert=UIAlertController(title: "Firebase", message: "Welcome to Firebase \(authUser.displayName!)", preferredStyle: UIAlertController.Style.alert)
                     
             //create a UIAlertAction object for the button
             let okAction=UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
             alert.addAction(okAction)
             self.present(alert, animated: true, completion: nil)
         
         guard let authError = error else { return }
      
         let errorCode = UInt((authError as NSError).code)
      
         switch errorCode {
         case FUIAuthErrorCode.userCancelledSignIn.rawValue:
             print("User cancelled sign-in");
             break
      
         default:
             let detailedError = (authError as NSError).userInfo[NSUnderlyingErrorKey] ?? authError
             print("Login error: \((detailedError as! NSError).localizedDescription)");
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
