//
//  SignUpViewController.swift
//  Skeye
//
//  Created by Kevin Dang on 3/28/17.
//  Copyright © 2017 Team_Skeye. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController {

    @IBOutlet weak var buttonStackView: UIStackView!
    
    //Buttons
    @IBOutlet weak var coordinatorButton: UIButton!
    {
        didSet
        {
            coordinatorButton.titleLabel?.adjustsFontSizeToFitWidth = true
        }
    }
    @IBOutlet weak var ownerButton: UIButton!
    {
        didSet
        {
            ownerButton.titleLabel?.adjustsFontSizeToFitWidth = true
        }
    }
    @IBOutlet weak var attendeeButton: UIButton!
    {
        didSet
        {
            attendeeButton.titleLabel?.adjustsFontSizeToFitWidth = true
        }
    }
    @IBOutlet weak var back: UIButton!
    {
        didSet
        {
            back.titleLabel?.adjustsFontSizeToFitWidth = true
        }
    }
    @IBOutlet weak var signUp: UIButton!
    {
        didSet
        {
            signUp.titleLabel?.adjustsFontSizeToFitWidth = true
        }
    }
    
    //Text Fields
    @IBOutlet weak var firstName: UITextField!
    @IBOutlet weak var lastName: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var confirmPassword: UITextField!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        coordinatorButton.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(buttonTouched)))
        ownerButton.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(buttonTouched)))
        attendeeButton.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(buttonTouched)))
        signUp.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(register)))
        back.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action:  #selector(cancel)))
    }
    
    func buttonTouched(gesture: UIGestureRecognizer)
    {
        let button = gesture.view as? UIButton
        let text = button?.titleLabel!.text!
        
        for subview in buttonStackView.subviews
        {
            if let button = subview as? UIButton
            {
                if button.titleLabel?.text == text
                {
                    button.backgroundColor = UIColor.init(red: 53.0/255, green: 220.0/255, blue: 53.0/255, alpha: 1)
                    button.setTitleColor(UIColor.black, for: .normal)
                }
                else
                {
                    //custom color we have chose for sign up, modify this later
                    button.backgroundColor = UIColor.init(red: 14.0/255, green: 97.0/255, blue: 90.0/255, alpha: 1)
                    button.setTitleColor(UIColor.white, for: .normal)
                }
            }
        }
    }
    
    func register(gesture: UITapGestureRecognizer)
    {
        //receiving text
        let firstNameText = firstName.text!
        let lastNameText = lastName.text!
        let emailText = email.text!
        let passwordText = password.text!
        let confirmPasswordText = confirmPassword.text!
        var permissionsText: Int = 0
        if(coordinatorButton.backgroundColor == UIColor.red)
        {
            permissionsText = 1
        }
        else if(ownerButton.backgroundColor == UIColor.red)
        {
            permissionsText = 2
        }
        else if(attendeeButton.backgroundColor == UIColor.red)
        {
            permissionsText = 3
        }
        
        //Email format testing
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        
        if(firstNameText.isEmpty || lastNameText.isEmpty || emailText.isEmpty || passwordText.isEmpty || confirmPasswordText.isEmpty)
        {
            displayAlertFailure("One or more text fields are not filled. Please try again.")
        }
        else if(emailTest.evaluate(with: emailText) == false)
        {
            displayAlertFailure("Email is not valid.")
        }
        else if(passwordText.characters.count < 8)
        {
            displayAlertFailure("Passwords must be 8 or more characters long.")
        }
        else if(passwordText != confirmPasswordText)
        {
            displayAlertFailure("Passwords do not match. Try again.")
        }
        else if(containsAllLetters(firstNameText) == false || containsAllLetters(lastNameText) == false)
        {
            displayAlertFailure("Name is not valid. Try again.")
        }
        else if(permissionsText == 0)
        {
            displayAlertFailure("Please select the type of user that will be using this account.")
        }
        else
        {
            //IP address
            let ipAddress = "http://130.65.159.80/Register.php"
            let url = URL(string: ipAddress)
            var request = URLRequest(url: url!)
            request.httpMethod = "POST"
            let postString = "email=\(emailText)&password=\(passwordText)&first_name=\(firstNameText)&last_name=\(lastNameText)&permissions=\(permissionsText)"
            request.httpBody = postString.data(using: String.Encoding.utf8)
            URLSession.shared.dataTask(with: request, completionHandler:
            {
                (data, response, error) -> Void in
                if(error != nil)
                {
                    print("error=\(String(describing: error))\n")
                    return
                }
                do
                {
                    let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? NSDictionary
                    if let parseJSON = json
                    {
                        let resultValue: String = parseJSON["status"] as! String
                        print("result: \(resultValue)\n")
                        
                        var isUserRegistered : Bool = false
                        if(resultValue == "success")
                        {
                            isUserRegistered = true
                        }
                        let messageToDisplay = parseJSON["message"] as! String!
                        
                        if(!isUserRegistered)
                        {
                            DispatchQueue.main.async
                            {
                                self.displayAlertFailure(messageToDisplay!)
                            }
                        }
                        else
                        {
                            DispatchQueue.main.async
                            {
                                self.displayAlertSuccess(messageToDisplay!)
                            }
                        }
                    }
                }
                catch let error as Error?
                {
                    print("Found an error - \(String(describing: error))")
                }

            }).resume()
            
        }
    }
    
    func displayAlertSuccess(_ message: String)
    {
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: UIAlertControllerStyle.alert)
        let ok = UIAlertAction(title: "OK", style: UIAlertActionStyle.default)
        {
            (action:UIAlertAction) in
            self.dismiss(animated: true, completion: nil)
        }
        alert.addAction(ok)
        self.present(alert, animated: true, completion: nil)
    }
    
    func displayAlertFailure(_ message: String)
    {
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: UIAlertControllerStyle.alert)
        let ok = UIAlertAction(title: "OK", style: UIAlertActionStyle.default)
        alert.addAction(ok)
        self.present(alert, animated: true, completion: nil)
    }
    
    /*
     Checks whether the text contains all letters
    */
    func containsAllLetters(_ text: String) -> Bool
    {
        for char in text.characters
        {
            if(!(char >= "a" && char <= "z") && !(char >= "A" && char <= "Z"))
            {
                return false
            }
        }
        return true

    }
    
    /*
     Returns to log in page
    */
    func cancel(_ gesture: UITapGestureRecognizer)
    {
        self.dismiss(animated: true, completion: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
