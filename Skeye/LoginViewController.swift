//
//  LoginViewController.swift
//  Skeye
//
//  Created by yoho chen on 3/28/17.
//  Copyright © 2017 Team Skeye. All rights reserved.
//

import UIKit

extension UITextField{
    @IBInspectable var placeHolderColor: UIColor? {
        get {
            return self.placeHolderColor
        }
        set {
            self.attributedPlaceholder = NSAttributedString(string:self.placeholder != nil ? self.placeholder! : "", attributes:[NSForegroundColorAttributeName: newValue!])
        }
    }
}



class LoginViewController: UIViewController,UITextFieldDelegate {
    
    //Text Fields
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    //Login and Sign Up Buttons
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signUpField: UIButton!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        scrollView.bounds = CGRect.init(origin: CGPoint.init(x: 0, y: 0), size: CGSize.init(width: self.view.bounds.width, height: self.view.bounds.height))
        loginButton.isEnabled = false
        signUpField.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(signUpPressed)))
    }
    
    //Check if username field is empty to enable login button
    @IBAction func usernameTextFieldChanged(_ sender: UITextField) {
        if (!(usernameTextField.text?.isEmpty)! && !(passwordTextField.text?.isEmpty)!)
        {
            loginButton.isEnabled = true
            loginButton.alpha = 1.0
        }
        else
        {
            loginButton.isEnabled = false
            loginButton.alpha = 0.2
        }
        
    }
    
    //Check if password field is empty to enable login button
    @IBAction func passwordTextFieldChanged(_ sender: UITextField) {
        if (!(usernameTextField.text?.isEmpty)! && !(passwordTextField.text?.isEmpty)!)
        {
            loginButton.isEnabled = true
            loginButton.alpha = 1.0
        }
        else{
            loginButton.isEnabled = false
            loginButton.alpha = 0.2
        }
    }
    
    
    
    @IBAction func loginButtonTapped(_ sender: UIButton)
    {
        //HTTP Request
        let email = usernameTextField.text!
        let password = passwordTextField.text!
        let ipAddress = "http://130.65.159.80/Login.php"
        let url = URL(string: ipAddress)
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        
        let postString = "email=\(email)&password=\(password)"
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
                        
                        if(resultValue == "success")
                        {
                            //Setting user defaults for later access
                            UserDefaults.standard.set(parseJSON["user"], forKey: "username")
                            UserDefaults.standard.set(Int(parseJSON["usertype"] as! String)!, forKey: "usertype")
                            UserDefaults.standard.set((parseJSON["first_name"] as! String) + " " + (parseJSON["last_name"] as! String), forKey: "name")
                            UserDefaults.standard.synchronize()
                            let messageToDisplay = parseJSON["message"] as! String!
                            DispatchQueue.main.async
                            {
                                self.displayAlertSuccess(messageToDisplay!)
                            }
                        }
                        else
                        {
                            let messageToDisplay = parseJSON["message"] as! String!
                            DispatchQueue.main.async
                            {
                                self.displayAlertFailure(messageToDisplay!)
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
    
    //User was not able to login
    private func displayAlertFailure(_ message: String)
    {
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: UIAlertControllerStyle.alert)
        let ok = UIAlertAction(title: "OK", style: UIAlertActionStyle.default)
        alert.addAction(ok)
        self.present(alert, animated: true, completion: nil)
    }
    
    //User is logged in and is redirected to search map page
    private func displayAlertSuccess(_ message: String)
    {
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: UIAlertControllerStyle.alert)
        let ok = UIAlertAction(title: "OK", style: UIAlertActionStyle.default)
        {
            (action:UIAlertAction) in
            let rootVC = UIApplication.shared.keyWindow?.rootViewController
            let searchController = rootVC!.storyboard!.instantiateViewController(withIdentifier: "TabBarController") as! TabBarController
            self.present(searchController, animated: true, completion: nil)
            
        }
        alert.addAction(ok)
        self.present(alert, animated: true, completion: nil)
    }
    
    //Sign Up button pressed to redirect to sign up view controller
    func signUpPressed(gesture: UITapGestureRecognizer)
    {
        let rootVC = UIApplication.shared.keyWindow?.rootViewController
        let signUpController = rootVC!.storyboard!.instantiateViewController(withIdentifier: "SignUpViewController") as! SignUpViewController
        self.present(signUpController, animated: true, completion: nil)
    }
    
    
    //Hides keyboard
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        self.view.endEditing(true)
        
    }


}
