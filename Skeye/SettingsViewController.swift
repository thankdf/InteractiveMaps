//
//  ViewController.swift
//  Test
//
//  Created by Hoa Hang on 4/21/17.
//  Copyright © 2017 Hoa Hang. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController,UITableViewDelegate {
    
    @IBOutlet weak var screen: UIView!
    @IBOutlet weak var lblReenterPwd: UILabel!
    {
        didSet
        {
            lblReenterPwd.adjustsFontSizeToFitWidth = true
        }
    }
    @IBOutlet weak var lblTitle: UILabel!
    {
        didSet
        {
            lblTitle.adjustsFontSizeToFitWidth = true
        }
    }
    @IBOutlet weak var lblNewPassword: UILabel!
    {
        didSet
        {
            lblNewPassword.adjustsFontSizeToFitWidth = true
        }
    }
    @IBOutlet weak var lblCurrentPassword: UILabel!
    {
        didSet
        {
            lblCurrentPassword.adjustsFontSizeToFitWidth = true
        }
    }
    @IBOutlet weak var lblUsername: UILabel!
    @IBOutlet weak var txtUserName: UITextField!
    @IBOutlet weak var txtReEnterPassword: UITextField!
    @IBOutlet weak var txtCurrentPassword: UITextField!
    @IBOutlet weak var txtNewPassword: UITextField!
    @IBOutlet weak var btnSubmit: UIButton!
    //@IBOutlet weak var btnCancel: UIButton!
    var email: String?;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let widthfactor = self.view.bounds.width/screen.bounds.width
        let heightfactor = self.view.bounds.height/screen.bounds.height
        screen.frame.size = CGSize.init(width: screen.bounds.width * widthfactor, height: screen.bounds.height * heightfactor)
        for subview in screen.subviews
        {
            subview.frame = CGRect.init(origin: CGPoint.init(x: subview.frame.origin.x * widthfactor, y: subview.frame.origin.y * heightfactor), size: CGSize.init(width: subview.bounds.width * widthfactor, height: subview.bounds.height * heightfactor))
        }

        // Do any additional setup after loading the view, typically from a nib.
        email = UserDefaults.standard.string(forKey: "username");//"hqhoak992003@gmail.com";
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func submitChangePassword(_ sender: UIButton)
    {
        let currPwd = txtCurrentPassword.text;
        let newPwd = txtNewPassword.text;
        let reEnterPwd = txtReEnterPassword.text;
        if(email == nil){
            displayAlertMessage(userMessage:"Missing username!!!");
            return;
        }
        if((currPwd?.isEmpty)! || (newPwd?.isEmpty)! || (reEnterPwd?.isEmpty)!){
            // display msg to notice old and new password are the same
            displayAlertMessage(userMessage:"All fields are not empty!!!");
            return;
        }
        if((newPwd?.characters.count)! < 8){
            // display msg to notice the password length
            displayAlertMessage(userMessage:"Password should have at least eight characters!!!");
            return;
        }
        if(currPwd == newPwd){
            // display msg to notice the same password
            displayAlertMessage(userMessage:"New Password is not the same current password!!!");
            return;
        }
        if(newPwd != reEnterPwd){
            // display msg to notice the same password
            displayAlertMessage(userMessage:"New password does not match!!!");
            return;
        }
        // get data and store
        let ipAddress = "http://130.65.159.80/user_setting.php"
        let url = URL(string: ipAddress)
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        
        let postString = "email=\(String(describing:email!))&newPassword=\(String(describing:newPwd!))&currPassword=\(String(describing:currPwd!))"
        
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
                        let messageToDisplay = parseJSON["message"] as! String!
                        DispatchQueue.main.async
                        {
                                self.displayAlertMessage(userMessage: messageToDisplay!);
                        }

                        
                        /*if(resultValue == "success")
                        {
                            UserDefaults.standard.set(parseJSON["user"], forKey: "username")
                            UserDefaults.standard.set(parseJSON["usertype"], forKey: "type")
                            UserDefaults.standard.synchronize()
                            self.dismiss(animated: true, completion: nil)
                            let messageToDisplay = parseJSON["message"] as! String!
                            DispatchQueue.main.async
                            {
                                self.displayAlertMessage(userMessage: messageToDisplay!);
                            }
                        }
                        else
                        {
                            let messageToDisplay = parseJSON["message"] as! String!
                            DispatchQueue.main.async
                                {
                                    self.displayAlertMessage(userMessage:messageToDisplay!)
                            }
                        }*/
                    }
                }
                catch let error as Error?
                {
                    print("Found an error - \(String(describing: error))")
                }
                
        }).resume()
    }
    
    @IBAction func logOut(_ sender: UIButton)
    {
        UserDefaults.standard.removeObject(forKey: "username")
        UserDefaults.standard.removeObject(forKey: "usertype")
        UserDefaults.standard.synchronize()
        //PFUser.
        self.displayAlertMessage(userMessage: "Logout is successful!!!")
        // Nagivate to the homepage
        let mainStoryBoard:UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let homePage = mainStoryBoard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        let homePageNav = UINavigationController(rootViewController: homePage)
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        appDelegate?.window?.rootViewController = homePageNav
        appDelegate?.window?.makeKeyAndVisible()
    }
    
    func displayAlertMessage(userMessage:String){
        let myAlert = UIAlertController(title:"Alert", message:userMessage, preferredStyle:UIAlertControllerStyle.alert);
        let okAction = UIAlertAction(title:"OK", style: UIAlertActionStyle.default, handler: nil);
        myAlert.addAction(okAction);
        self.present(myAlert, animated: true, completion:nil);
        
    }
}

