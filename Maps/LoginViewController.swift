//
//  LoginControllerViewController.swift
//  Maps
//
//  Created by Kevin Dang on 11/18/16.
//  Copyright © 2016 Team_Interactive_Maps. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController
{
    
    @IBOutlet weak var usernameField: UITextField!
    
    @IBOutlet weak var passwordField: UITextField!
    
    @IBOutlet weak var loginButton: UIButton!
    
    @IBOutlet weak var signUpButton: UIButton!
    
    @IBOutlet weak var forgotPasswordButton: UIButton!
    
    /*
     Function that handles buttons pressed
     */
    @IBAction func buttonPressed(sender: UIButton)
    {
        if let title = sender.titleLabel!.text
        {
            switch(title)
            {
            case("Login"):
                verifyLogin()
            case("Sign Up"):
                let mainController = (storyboard?.instantiateViewController(withIdentifier: "SignUpViewController"))! as UIViewController
                self.present(mainController, animated: true, completion: nil)
            default: break
            }
        }
    }
    
    func verifyLogin()
    {
        if ((usernameField.text?.isEmpty)! || (passwordField.text?.isEmpty)!)
        {
            print("One or more fields are empty. Please try again.")
        }
        else
        {
            if ((passwordField.text?.characters.count)! < 8)
            {
                print("Password must be at least 8 characters long.")
            }
            if (usernameField.text == User().username && passwordField.text == User().password)
            {
                //let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let mainController = (storyboard?.instantiateViewController(withIdentifier: "MapViewController"))! as UIViewController
                self.present(mainController, animated: true, completion: nil)
            }
        }
    }

}
