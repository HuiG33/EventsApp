//
//  ExtensionClass.swift
//  loginwithemailpass
//
//  Created by Joni Tefke on 22.1.2019.
//  Copyright © 2019 jonitefke. All rights reserved.
//

import Foundation
import FirebaseAuth

// connect error messages with error code
extension AuthErrorCode {
    var errorMessage: String {
        switch self {
        case .invalidEmail, .userNotFound, .wrongPassword, .invalidSender, .invalidRecipientEmail:
            return "Wrong email or password."
        case .emailAlreadyInUse:
            return "The email is already in use by another account."
        case .networkError:
            return "Network error. Please try again."
        default:
            return "Unknown error occurred"
        }
    }
}

// if error accure show the user a alert message
extension UIViewController{
    func handleError(_ error: Error) {
        if let errorCode = AuthErrorCode(rawValue: error._code) {
            print(errorCode.errorMessage)
            let alert = UIAlertController(title: "Error", message: errorCode.errorMessage, preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
            
            alert.addAction(okAction)
            
            self.present(alert, animated: true, completion: nil)
            
        }
    }
}
