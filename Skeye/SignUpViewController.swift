//
//  SignUpViewController.swift
//  Skeye
//
//  Created by Kevin Dang on 3/28/17.
//  Copyright © 2017 Team_Skeye. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController {
    
    @IBOutlet weak var screen: UIView!
    
    @IBOutlet weak var titleLabel: UILabel!
    {
        didSet
        {
            titleLabel.adjustsFontSizeToFitWidth = true
        }
    }
    @IBOutlet weak var userLabel: UILabel!
    {
        didSet
        {
            userLabel.adjustsFontSizeToFitWidth = true
        }
    }
    
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
    
    var buttons: [UIButton] = []
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        let widthfactor = self.view.bounds.width/screen.bounds.width
        let heightfactor = self.view.bounds.height/screen.bounds.height
        screen.frame.size = CGSize.init(width: screen.bounds.width * widthfactor, height: screen.bounds.height * heightfactor)
        for subview in screen.subviews
        {
            subview.frame = CGRect.init(origin: CGPoint.init(x: subview.frame.origin.x * widthfactor, y: subview.frame.origin.y * heightfactor), size: CGSize.init(width: subview.bounds.width * widthfactor, height: subview.bounds.height * heightfactor))
        }

        coordinatorButton.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(buttonTouched)))
        ownerButton.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(buttonTouched)))
        attendeeButton.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(buttonTouched)))
        signUp.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(register)))
        back.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action:  #selector(cancel)))
        buttons.append(coordinatorButton)
        buttons.append(ownerButton)
        buttons.append(attendeeButton)
    }
    
    func buttonTouched(_ gesture: UITapGestureRecognizer)
    {
        let button = gesture.view as! UIButton
        let text = button.titleLabel!.text!
        
        for subview in buttons
        {
           if button.titleLabel?.text == subview.titleLabel?.text
           {
                subview.backgroundColor = UIColor.init(red: 53.0/255, green: 220.0/255, blue: 53.0/255, alpha: 1)
                subview.setTitleColor(UIColor.black, for: .normal)
           }
           else
           {
                subview.backgroundColor = UIColor.init(red: 14.0/255, green: 97.0/255, blue: 90.0/255, alpha: 1)
                subview.setTitleColor(UIColor.white, for: .normal)
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
        if(coordinatorButton.backgroundColor == UIColor.init(red: 53.0/255, green: 220.0/255, blue: 53.0/255, alpha: 1))
        {
            permissionsText = 1
        }
        else if(ownerButton.backgroundColor == UIColor.init(red: 53.0/255, green: 220.0/255, blue: 53.0/255, alpha: 1))
        {
            permissionsText = 2
        }
        else if(attendeeButton.backgroundColor == UIColor.init(red: 53.0/255, green: 220.0/255, blue: 53.0/255, alpha: 1))
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
            //HTML Request
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
