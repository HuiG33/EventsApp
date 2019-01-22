//
//  ResetPasswordViewController.swift
//  loginwithemailpass
//
//  Created by Joni Tefke on 21.1.2019.
//  Copyright © 2019 jonitefke. All rights reserved.
//

import Foundation
import UIKit
import FirebaseAuth

class ResetPasswordViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var emailTextField: UITextField!
    
    var activityIndicator:UIActivityIndicatorView = UIActivityIndicatorView()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailTextField.delegate = self
        
        initLoadingIndicator()
    }
    
    // send a password reset mesage to given email
    @IBAction func resetPass(_ sender: UIButton) {
        if !emailTextField.text!.isEmpty {
            activityIndicator.startAnimating()
            Auth.auth().sendPasswordReset(withEmail: emailTextField.text!) {(error) in
                
                if (error != nil){
                    print(error!)
                    self.activityIndicator.stopAnimating()
                    return
                }
                else {
                    print("success")
                    self.activityIndicator.stopAnimating()
                }
            }
        }
        else {
            print("Enter email")
        }
    }
    
    func initLoadingIndicator() {
        activityIndicator.center = self.view.center
        activityIndicator.frame = self.view.bounds
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style = UIActivityIndicatorView.Style.whiteLarge
        activityIndicator.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        self.view.addSubview(activityIndicator)
    }
    
}
