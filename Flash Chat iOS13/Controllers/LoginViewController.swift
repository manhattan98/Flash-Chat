//
//  LoginViewController.swift
//  Flash Chat iOS13
//
//  Created by Angela Yu on 21/10/2019.
//  Copyright © 2019 Angela Yu. All rights reserved.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    
    override func viewDidLoad() {
        emailTextfield.delegate = self
        passwordTextfield.delegate = self
    }
    
    @IBAction func loginPressed(_ sender: UIButton) {
        tryLogin()
    }
    
    func tryLogin() {
        if let email = emailTextfield.text, let password = passwordTextfield.text, !email.isEmpty && !password.isEmpty {
            if Auth.auth().currentUser != nil {
                try? Auth.auth().signOut()
            }
            Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
                if let errorHappened = error {
                    print(errorHappened.localizedDescription)
                } else {
                    self.performSegue(withIdentifier: K.loginSegue, sender: self)
                }
            }
        } else if Auth.auth().currentUser != nil {
            self.performSegue(withIdentifier: K.loginSegue, sender: self)
        }
    }
}


// MARK:- UITextFieldDelegate conformance
extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        return !(textField.text?.isEmpty ?? true)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        tryLogin()
    }
}
