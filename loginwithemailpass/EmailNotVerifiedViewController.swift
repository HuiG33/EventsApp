//
//  EmailNotVerifiedViewController.swift
//  loginwithemailpass
//
//  Created by Joni Tefke on 23.12.2018.
//  Copyright © 2018 jonitefke. All rights reserved.
//

import Foundation
import UIKit
import FirebaseAuth

class EmailNotVerifiedViewController: UIViewController, UITextFieldDelegate {
    
    let firebaseAuth = Auth.auth()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func verifyEmail(_ sender: UIButton) {
        verifyEmail()
    }
    
    @IBAction func logout(_ sender: UIButton) {
        do {
            try firebaseAuth.signOut()
            presentAnotherView(viewControllerIdentifier: "LoginViewController")
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
    }
    
    func verifyEmail() {
        firebaseAuth.currentUser?.sendEmailVerification { (error) in
            
            // if not successfully sent, give error message
            // user can try resend the message
            if (error != nil) {
                print("Vericifation email could not be sent: ", error!)
            } else {
                print("Verification email sent successfully!")
            }
        }
    }
    
    func presentAnotherView(viewControllerIdentifier: String) {
        let viewController = self.storyboard?.instantiateViewController(withIdentifier: viewControllerIdentifier)
        self.present(viewController!, animated: false, completion: nil)
    }
    
}
