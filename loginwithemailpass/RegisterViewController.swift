//
//  RegisterViewController.swift
//  loginwithemailpass
//
//  Created by Joni Tefke on 22.12.2018.
//  Copyright © 2018 jonitefke. All rights reserved.
//

import Foundation
import UIKit
import FirebaseAuth
import FirebaseDatabase

class RegisterViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var confirmEmailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var confirmEmailLabel: UILabel!
    @IBOutlet weak var passwordLabel: UILabel!
    @IBOutlet weak var confirmPasswordLabel: UILabel!
    
    var ref: DatabaseReference!
    var activityIndicator:UIActivityIndicatorView = UIActivityIndicatorView()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = Database.database().reference()
        
        nameTextField.delegate = self
        emailTextField.delegate = self
        confirmEmailTextField.delegate = self
        passwordTextField.delegate = self
        confirmPasswordTextField.delegate = self
        
        nameLabel.isHidden = true
        emailLabel.isHidden = true
        confirmEmailLabel.isHidden = true
        passwordLabel.isHidden = true
        confirmPasswordLabel.isHidden = true
        
        nameLabel.textColor = UIColor.red
        emailLabel.textColor = UIColor.red
        confirmEmailLabel.textColor = UIColor.red
        passwordLabel.textColor = UIColor.red
        confirmPasswordLabel.textColor = UIColor.red
        
        initLoadingIndicator()
    }
    
    @IBAction func registerUser(_ sender: UIButton) {
        if validateForm(name: nameTextField.text, email: emailTextField.text, confirmEmail: confirmEmailTextField.text, password: passwordTextField.text, confirmPassword: confirmPasswordTextField.text) {
            registerUser()
            activityIndicator.startAnimating()
        }
    }
    
    // realtime feedback for the nameTextField
    @IBAction func nameEditingEnd(_ sender: UITextField) {
        if nameTextField.text!.isEmpty {
            nameLabel.text = "Please enter your name"
            nameLabel.isHidden = false
        }
        else {
            nameLabel.isHidden = true
        }
    }
    
    // realtime feedback for the emailTextField
    @IBAction func emailEditingEnd(_ sender: UITextField) {
        if emailTextField.text!.isEmpty {
            emailLabel.text = "Please enter email"
            emailLabel.isHidden = false
        }
        else if emailTextField.text! != confirmEmailTextField.text!{
            if !confirmEmailTextField.text!.isEmpty {
                emailLabel.text = "Emails does not match"
                confirmEmailLabel.text = "Emails does not match"
                emailLabel.isHidden = false
                confirmEmailLabel.isHidden = false
            }
        }
        else {
            emailLabel.isHidden = true
            confirmEmailLabel.isHidden = true
        }
    }
    
    // realtime feedback for the confirmEmailTextField
    @IBAction func confirmEmailEditingEnd(_ sender: UITextField) {
        if confirmEmailTextField.text!.isEmpty {
            confirmEmailLabel.text = "Please confirm email"
            confirmEmailLabel.isHidden = false
        }
        else if confirmEmailTextField.text! != emailTextField.text!{
            confirmEmailLabel.text = "Emails does not match"
            emailLabel.text = "Emails does not match"
            confirmEmailLabel.isHidden = false
            emailLabel.isHidden = false
        }
        else {
            confirmEmailLabel.isHidden = true
            emailLabel.isHidden = true
        }
    }
    
    // realtime feedback for the passwordTextField
    @IBAction func passwordEditingEnd(_ sender: UITextField) {
        if passwordTextField.text!.isEmpty {
            passwordLabel.text = "Please enter password"
            passwordLabel.isHidden = false
        }
        else if passwordTextField.text! != confirmPasswordTextField.text!{
            if !confirmPasswordTextField.text!.isEmpty {
                passwordLabel.text = "Passwords does not match"
                confirmPasswordLabel.text = "Passwords does not match"
                passwordLabel.isHidden = false
                confirmPasswordLabel.isHidden = false
            }
        }
        else {
            passwordLabel.isHidden = true
            confirmPasswordLabel.isHidden = true
        }
    }
    
    // realtime feedback for the confirmPasswordTextField
    @IBAction func confirmPasswordEditingEnd(_ sender: UITextField) {
        if confirmPasswordTextField.text!.isEmpty {
            confirmPasswordLabel.text = "Please confirm password"
            confirmPasswordLabel.isHidden = false
        }
        else if confirmPasswordTextField.text! != passwordTextField.text!{
            confirmPasswordLabel.text = "Passwords does not match"
            passwordLabel.text = "Passwords does not match"
            confirmPasswordLabel.isHidden = false
            passwordLabel.isHidden = false
        }
        else {
            confirmPasswordLabel.isHidden = true
            passwordLabel.isHidden = true
        }
    }
    
    // create user account, handle possible errors
    func registerUser(){
        Auth.auth().createUser(withEmail: emailTextField.text!, password: passwordTextField.text!, completion: { (authResult, error) in
            
            // if not succes, give error message
            if (error != nil){
                print(error!)
                self.activityIndicator.stopAnimating()
                self.handleError(error!)
                return
            }
            // successfully registered, save user data to database
            else {
                print("Success")
                
                let user = authResult!.user
                
                self.saveUserToFirebaseDatabase(uid: user.uid, email: self.emailTextField.text!, name: self.nameTextField.text!)
            }
        })
    }
    
    // save user data to database
    func saveUserToFirebaseDatabase(uid: String, email: String, name: String) {
        
        self.ref.child("users").child(uid).setValue(["uid": uid, "email": email, "name": name]){
            (error:Error?, ref:DatabaseReference) in
            
            // if not success, give error message and go to email verification
            // TODO pass data to viewcontroller and tell user to try again to save data
            if (error != nil) {
                print("Data could not be saved: ", error!)
                self.activityIndicator.stopAnimating()
                self.handleError(error!)
                self.presentAnotherView(viewControllerIdentifier: "EmailNotVerifiedViewController")
            }
            // successfully saved data to database, send verification email to the user
            else {
                print("Data saved successfully!")
                self.verifyEmail()
            }
        }
    }
    
    // send verification email to the user
    func verifyEmail() {
        Auth.auth().currentUser?.sendEmailVerification { (error) in
            
            // if not successfully sent, go to email verification
            // user can try resend the message
            if (error != nil) {
                print("Vericifation email could not be sent: ", error!)
                self.activityIndicator.stopAnimating()
                self.handleError(error!)
                self.presentAnotherView(viewControllerIdentifier: "EmailNotVerifiedViewController")
            } else {
                print("Verification email sent successfully!")
                self.activityIndicator.stopAnimating()
                self.presentAnotherView(viewControllerIdentifier: "EmailNotVerifiedViewController")
            }
        }
    }
    
    // validate the user input before creating a new user
    func validateForm(name: String?, email: String?, confirmEmail: String?, password: String?, confirmPassword: String?) -> Bool {
        
        if name!.isEmpty {
            nameLabel.text = "Please enter your name"
            nameLabel.isHidden = false
            return false
        }
        else {
            nameLabel.isHidden = true
        }
        
        if email != confirmEmail {
            emailLabel.text = "Emails does not match"
            emailLabel.isHidden = false
            confirmEmailLabel.text = "Emails does not match"
            confirmEmailLabel.isHidden = false
            return false
        }
        else {
            if email!.isEmpty {
                emailLabel.text = "Please enter email"
                emailLabel.isHidden = false
                return false
            }
            else {
                emailLabel.isHidden = true
            }
            
            if confirmEmail!.isEmpty {
                confirmEmailLabel.text = "Please confirm email"
                confirmEmailLabel.isHidden = false
                return false
            }
            else {
                confirmEmailLabel.isHidden = true
            }
        }
        
        if password != confirmPassword {
            passwordLabel.text = "Passwords does not match"
            passwordLabel.isHidden = false
            confirmPasswordLabel.text = "Passwords does not match"
            confirmPasswordLabel.isHidden = false
            return false
        }
        else {
            if password!.isEmpty {
                passwordLabel.text = "Please enter password"
                passwordLabel.isHidden = false
                return false
            }
            else {
                passwordLabel.isHidden = true
            }
            
            if confirmPassword!.isEmpty {
                confirmPasswordLabel.text = "Please confirm password"
                confirmPasswordLabel.isHidden = false
                return false
            }
            else {
                confirmPasswordLabel.isHidden = true
            }
        }
        
        return true
    }
    
    func initLoadingIndicator() {
        activityIndicator.center = self.view.center
        activityIndicator.frame = self.view.bounds
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style = UIActivityIndicatorView.Style.whiteLarge
        activityIndicator.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        self.view.addSubview(activityIndicator)
    }
    
    func presentAnotherView(viewControllerIdentifier: String) {
        let viewController = self.storyboard?.instantiateViewController(withIdentifier: viewControllerIdentifier)
        self.present(viewController!, animated: false, completion: nil)
    }
}
