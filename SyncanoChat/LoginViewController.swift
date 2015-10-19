//
//  LoginViewController.swift
//  SyncanoChat
//
//  Created by Mariusz Wisniewski on 10/19/15.
//  Copyright © 2015 Mariusz Wisniewski. All rights reserved.
//

import UIKit
import syncano_ios

let loginViewControllerIdentifier = "LoginViewController"

protocol LoginDelegate {
    func didSignUp()
    func didLogin()
}

class LoginViewController: UIViewController {
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    var delegate : LoginDelegate?
}

//MARK - UI
extension LoginViewController {
    @IBAction func loginPressed(sender: UIButton) {
        if self.areBothUsernameAndPasswordFilled() {
            self.login(self.getUsername()!, password: self.getPassword()!, finished: { error in
                if (error != nil) {
                    //handle error
                    print("Login, error: \(error)")
                } else {
                    self.cleanTextFields()
                    self.delegate?.didLogin()
                }
                
            })
        }
    }
    
    @IBAction func signUpPressed(sender: UIButton) {
        if self.areBothUsernameAndPasswordFilled() {
            self.signUp(self.getUsername()!, password: self.getPassword()!, finished: { error in
                if (error != nil) {
                    //handle error
                    print("Sign Up, error: \(error)")
                } else {
                    self.cleanTextFields()
                    self.delegate?.didSignUp()
                }
            })
        }
    }
    
    func getUsername() -> String? {
        return self.emailTextField.text
    }
    
    func getPassword() -> String? {
        return self.passwordTextField.text
    }
    
    func areBothUsernameAndPasswordFilled() -> Bool {
        if let username = self.emailTextField.text, password = self.passwordTextField.text {
            if (username.characters.count > 0 && password.characters.count > 0) {
                return true
            }
        }
        return false
    }
    
    func cleanTextFields() {
        self.emailTextField.text = nil
        self.passwordTextField.text = nil
    }
}

//MARK - Syncano
extension LoginViewController {
    func login(username: String, password: String, finished: (NSError!) -> ()) {
        SCUser.loginWithUsername(username, password: password) { error in
            finished(error)
        }
    }
    
    func signUp(username: String, password: String, finished: (NSError!) -> ()) {
        SCUser.registerWithUsername(username, password: password) { error in
            finished(error)
        }
    }
}