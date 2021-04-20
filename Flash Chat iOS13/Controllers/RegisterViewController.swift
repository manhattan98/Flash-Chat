//
//  RegisterViewController.swift
//  Flash Chat iOS13
//
//  Created by Angela Yu on 21/10/2019.
//  Copyright © 2019 Angela Yu. All rights reserved.
//

import UIKit
import FirebaseAuth

class RegisterViewController: UIViewController {

    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    
    override func viewDidLoad() {
        emailTextfield.delegate = self
        passwordTextfield.delegate = self
    }
    
    @IBAction func registerPressed(_ sender: UIButton) {
        tryRegister()
    }
    
    func tryRegister() {
        if let email = emailTextfield.text, let password = passwordTextfield.text {
            if Auth.auth().currentUser != nil {
                try? Auth.auth().signOut()
            }
            Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                if let errorHappened = error {
                    print(errorHappened.localizedDescription)
                } else {
                    self.performSegue(withIdentifier: K.registerSegue, sender: self)
                }
            }
        }
    }
    
}

// MARK:- UITextFieldDelegate conformance
extension RegisterViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        return !(textField.text?.isEmpty ?? true)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        tryRegister()
    }
}
