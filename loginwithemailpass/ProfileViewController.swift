//
//  ProfileViewController.swift
//  loginwithemailpass
//
//  Created by Joni Tefke on 23.12.2018.
//  Copyright © 2018 jonitefke. All rights reserved.
//

import Foundation
import UIKit
import FirebaseAuth

class ProfileViewController: UIViewController, UITextFieldDelegate {
    
    let firebaseAuth = Auth.auth()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        if (firebaseAuth.currentUser != nil) {
            print(firebaseAuth.currentUser!.isEmailVerified)
            if (!firebaseAuth.currentUser!.isEmailVerified){
                print("Stuff")
                presentAnotherView(viewControllerIdentifier: "EmailNotVerifiedViewController")
            }
        }

    }

    @IBAction func logoutButton(_ sender: UIButton) {
        do {
            try firebaseAuth.signOut()
            presentAnotherView(viewControllerIdentifier: "LoginViewController")
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
    }
    
    func presentAnotherView(viewControllerIdentifier: String) {
        let viewController = self.storyboard?.instantiateViewController(withIdentifier: viewControllerIdentifier)
        self.present(viewController!, animated: false, completion: nil)
    }
}
