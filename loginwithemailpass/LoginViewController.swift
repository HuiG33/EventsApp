//
//  ViewController.swift
//  loginwithemailpass
//
//  Created by Joni Tefke on 22.12.2018.
//  Copyright © 2018 jonitefke. All rights reserved.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    var eyeButton = UIButton(type: .custom)
    var isPassShowing = false
    var activityIndicator:UIActivityIndicatorView = UIActivityIndicatorView()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailTextField.delegate = self
        passwordTextField.delegate = self
        
        initTextFieldButton()
        
        initLoadingIndicator()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        let currentUser = Auth.auth().currentUser

        // if user is already logged in, go to profile
        if (currentUser != nil) {
            print("User email: ", currentUser!.email!)
            presentAnotherView(viewControllerIdentifier: "ProfileViewController")
        }
    }
    
    @IBAction func loginButton(_ sender: UIButton) {
        if emailTextField.text!.isEmpty || passwordTextField.text!.isEmpty {
            let alert = UIAlertController(title: "Error", message: "Please fill in the both fields", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
        }
        else {
            login(email: emailTextField.text!, password: passwordTextField.text!)
            activityIndicator.startAnimating()
        }
    }
    
    // login, if some error accure, show the user a alert message
    // if successfull go to profile
    func login(email: String, password: String) {
        Auth.auth().signIn(withEmail: email, password: password) {
            (user, error) in
            
            if (error != nil){
                print(error!)
                self.handleError(error!)
                self.activityIndicator.stopAnimating()
                return
            }
            else {
                self.activityIndicator.stopAnimating()
                self.presentAnotherView(viewControllerIdentifier: "ProfileViewController")
            }
        }
    }
    
    func presentAnotherView(viewControllerIdentifier: String) {
        let viewController = self.storyboard?.instantiateViewController(withIdentifier: viewControllerIdentifier)
        self.present(viewController!, animated: false, completion: nil)
    }
    
    func initLoadingIndicator() {
        activityIndicator.center = self.view.center
        activityIndicator.frame = self.view.bounds
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style = UIActivityIndicatorView.Style.whiteLarge
        activityIndicator.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        self.view.addSubview(activityIndicator)
    }
    
    // initialize password hide/show button in passwordTextField
    func initTextFieldButton() {
        eyeButton.setImage(UIImage(named: "baseline_visibility_off_black_18dp.png"), for: .normal)
        eyeButton.addTarget(self, action: #selector(self.togglePass), for: .touchUpInside)
        eyeButton.frame = CGRect(x: 0, y: 0, width: 32, height: passwordTextField.frame.height)
        
        passwordTextField.rightViewMode = .always
        passwordTextField.rightView = eyeButton
    }
    
    // toggle between showing and not showing the password
    @objc func togglePass() {
        if isPassShowing {
            isPassShowing = false
            eyeButton.setImage(UIImage(named: "baseline_visibility_off_black_18dp.png"), for: .normal)
            passwordTextField.isSecureTextEntry.toggle()
        }
        else {
            isPassShowing = true
            eyeButton.setImage(UIImage(named: "baseline_visibility_black_18dp.png"), for: .normal)
            passwordTextField.isSecureTextEntry.toggle()
        }
    }
}
