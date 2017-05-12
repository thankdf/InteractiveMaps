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





class LoginViewController: UIViewController,UITextFieldDelegate, UIScrollViewDelegate, UIPopoverPresentationControllerDelegate, DataSentDelegate {
    
    @IBOutlet weak var usernameTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var loginButton: UIButton!
    
    @IBOutlet weak var signUpField: UIButton!
    
    
    
    /* Delegate-related: mainVC implement protocol fucntion*/
    internal func userDidEditInfo(data: String, whichBooth: BoothShape) {
        whichBooth.info = data
    }
    internal func userDidEditName(data: String, whichBooth: BoothShape) {
        whichBooth.name = data
    }
    internal func userDidUploadPic(data: [UIImage], whichBooth: BoothShape){
        whichBooth.boothPhotos = data
    }
    internal func userDidEditDate(data: String, whichBooth: BoothShape) {
        whichBooth.date = data
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        loginButton.isEnabled = false
        signUpField.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(signUpPressed)))
    }
    
//    func textFieldShouldReturn(_ textField: UITextField) -> Bool// called when 'return' key pressed. return NO to ignore.
//    {
//        textField.resignFirstResponder()
//        return true;
//    }
    
    //check empty textfield
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
    
    //check empty textfield
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
    
    private func displayAlertFailure(_ message: String)
    {
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: UIAlertControllerStyle.alert)
        let ok = UIAlertAction(title: "OK", style: UIAlertActionStyle.default)
        alert.addAction(ok)
        self.present(alert, animated: true, completion: nil)
    }
    
    
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
    
    func signUpPressed(gesture: UITapGestureRecognizer)
    {
        let rootVC = UIApplication.shared.keyWindow?.rootViewController
        let signUpController = rootVC!.storyboard!.instantiateViewController(withIdentifier: "SignUpViewController") as! SignUpViewController
        self.present(signUpController, animated: true, completion: nil)
    }
    
    
    //to hide keyboard
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        self.view.endEditing(true)
        
    }

    func popOver(_ sender: AnyObject)
    {
        /* This is the line of code that calls the 'prepareforSegue' method */
        //performSegue(withIdentifier: "editBoothPopover", sender: sender)
        
        let castedSender : BoothShape = sender as! BoothShape
        
        //print(sender.name)
        /* This is the line of code that calls the 'prepareforSegue' method,but we are not using it */
        //performSegue(withIdentifier: "editBoothPopover", sender: sender)
        //print(castedSender.name + " Here!")
        
        
        
        let rootVC = UIApplication.shared.keyWindow?.rootViewController
        
        //print(NSStringFromClass(rootVC!.classForCoder))
        
        
        //let strBoard = UIStoryboard(name: "Main", bundle: nil)
        let popoverController = rootVC!.storyboard!.instantiateViewController(withIdentifier: "EditBoothViewController") as! EditBoothViewController
        
        
        //get a reference to the view controller for the popover
        popoverController.boothRef = castedSender //as? BoothShape
        popoverController.name = castedSender.name
        popoverController.info = castedSender.info
        popoverController.date = castedSender.date
        popoverController.boothImages = castedSender.boothPhotos
        popoverController.delegate = self
        
        // set the presentation style
        popoverController.modalPresentationStyle = UIModalPresentationStyle.popover
        
        // set up the popover presentation controller
        popoverController.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection.any
        popoverController.popoverPresentationController?.delegate = self
        popoverController.popoverPresentationController?.sourceView = castedSender.button
        
        // set anchor programatically
        popoverController.popoverPresentationController?.sourceRect = castedSender.button.bounds
        
        // present the popover
        self.present(popoverController, animated: true, completion: nil)
    }


}
