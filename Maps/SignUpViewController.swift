//
//  SignUpViewController.swift
//  Maps
//
//  Created by Kevin Dang on 11/18/16.
//  Copyright © 2016 Team_Interactive_Maps. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController
{
    @IBOutlet weak var firstNameField: UITextField!
    
    @IBOutlet weak var lastNameField: UITextField!
    
    @IBOutlet weak var emailField: UITextField!
    
    @IBOutlet weak var usernameField: UITextField!
    
    @IBOutlet weak var passwordField: UITextField!
    
    @IBOutlet weak var confirmPasswordField: UITextField!
    
    /*
     Function that handles buttons pressed
     */
    @IBAction func buttonPressed(sender: UIButton)
    {
        if let title = sender.titleLabel!.text
        {
            switch(title)
            {
            case("Enter"):
                signUp()
            case("Back"):
                let mainController = (storyboard?.instantiateViewController(withIdentifier: "LoginViewController"))! as UIViewController
                self.present(mainController, animated: true, completion: nil)
            default: break
            }
        }
    }
    
    func signUp()
    {
        if((firstNameField.text?.isEmpty)! || (lastNameField.text?.isEmpty)! || (emailField.text?.isEmpty)!
            || (usernameField.text?.isEmpty)! || (passwordField.text?.isEmpty)! || (confirmPasswordField.text?.isEmpty)!)
        {
            print("One or more fields are empty. Please try again.")
        }
        else if((passwordField.text?.characters.count)! < 8)
        {
            print("Password must be at least 8 characters long.")
        }
        else if(passwordField.text != confirmPasswordField.text)
        {
            print("Passwords do not match. Please try again.")
        }
        else if(!isValidEmail(email: emailField.text!))
        {
            print("Email is not valid. Please try again.")
        }
        else
        {
            let mainController = (storyboard?.instantiateViewController(withIdentifier: "LoginViewController"))! as UIViewController
            self.present(mainController, animated: true, completion: nil)
        }
    }
    
    func isValidEmail(email: String) -> Bool
    {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: email)
    }
}
