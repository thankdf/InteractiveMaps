//
//  ViewController.swift
//  Skeye
//
//  Created by Kevin Dang on 2/6/17.
//  Copyright © 2017 Team_Skeye. All rights reserved.
//

import UIKit

class MapViewController: UIViewController, UIScrollViewDelegate, UIPopoverPresentationControllerDelegate
//    DataSentDelegate
{
//    /* Returns data from Edit Booth View Controller to save*/
//    internal func userDidEditInfo(data: String, whichBooth: BoothShape) {
//        whichBooth.info = data
//    }
//    internal func userDidEditName(data: String, whichBooth: BoothShape) {
//        whichBooth.name = data
//    }
//    internal func userDidUploadPic(data: [UIImage], whichBooth: BoothShape){
//        whichBooth.boothPhotos = data
//    }
//    internal func userDidEditDate(data: String, whichBooth: BoothShape) {
//        whichBooth.date = data
//    }

    
    /* Map Boundaries */
    @IBOutlet weak var scrollView: UIScrollView!
    {
        didSet
        {
            scrollView.backgroundColor = UIColor.white
            scrollView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        }
    }
    
    var selectedLocation : LocationModel?
    
    /* Background Image */
    var mapImage: UIImageView!
    {
        didSet
        {
            mapImage.isUserInteractionEnabled = true
        }
    }
    /* Adjust sizes */
    @IBOutlet weak var navBar: UINavigationBar!
    @IBOutlet weak var stack: UIStackView!
    @IBOutlet weak var permissionsBar: UIView!
    @IBOutlet weak var deleteAndInfoBar: UIView!
    
    /* Booleans */
    var shapeSelected = false //if user selected a shape before tapping on the screen
    var changeShapeButtonPressed = false //if the user wants to change the shape of the button
    var changeColorButtonPressed = false //if the user wants to change the color of the button
    var deleteButtonPressed = false //if the user wants to delete a booth
    
    /* Objects obtained from the database */
    var booths: [BoothShape] = [BoothShape]() //list of booths

    /* Gesture recognizers */
    var select: UITapGestureRecognizer = UITapGestureRecognizer.init()
    
    /* For Undo function */
    var lastBooth: BoothShape? = nil
    var currentBooth: BoothShape? = nil
    
    /* Buttons */
    @IBOutlet weak var boothButton: UIButton!
    {
        didSet
        {
            boothButton.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(turnOnShape)))
            boothButton.titleLabel?.adjustsFontSizeToFitWidth = true
        }
    }
    
    @IBOutlet weak var shapeButton: UIButton!
    {
        didSet
        {
            shapeButton.titleLabel?.adjustsFontSizeToFitWidth = true
            shapeButton.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(shapeButtonPressed)))
        }
    }
    
    @IBOutlet weak var colorButton: UIButton!
    {
        didSet
        {
            colorButton.titleLabel?.adjustsFontSizeToFitWidth = true
            colorButton.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(colorButtonPressed)))
        }
    }
    
    @IBOutlet weak var undoButton: UIButton!
    {
        didSet
        {
            undoButton.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(undo)))
            undoButton.setTitleColor(UIColor.gray, for: .disabled)
            undoButton.isEnabled = false
            undoButton.titleLabel?.adjustsFontSizeToFitWidth = true
        }
    }
    @IBOutlet weak var saveButton: UIButton!
    {
        didSet
        {
            saveButton.titleLabel?.adjustsFontSizeToFitWidth = true
            saveButton.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(save)))
        }
    }
    
    @IBOutlet weak var permissionsSaveButton: UIButton!
    {
        didSet
        {
            permissionsSaveButton.titleLabel?.adjustsFontSizeToFitWidth = true
            permissionsSaveButton.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(changePermissions)))
        }
    }
    
    @IBOutlet weak var mapInfo: UIButton!
    {
        didSet
        {
            mapInfo.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(popOver(_:))))
        }
    }
    
    @IBOutlet weak var deleteBooth: UIButton!
    {
        didSet
        {
            deleteBooth.titleLabel?.adjustsFontSizeToFitWidth = true
            deleteBooth.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(enableDeleteBooth)))
        }
    }
    
    /* Permissions Text Field */
    @IBOutlet weak var permissionsText: UITextField!
    {
        didSet
        {
            permissionsText.isEnabled = false
        }
    }
    
    
    /* Event name */
    @IBOutlet weak var mapName: UINavigationItem!
    {
        didSet
        {
            mapName.title = "Title"
        }
    }
    
    /* Permissions Label */
    @IBOutlet weak var permissionsLabel: UILabel!
    {
        didSet
        {
            permissionsLabel.adjustsFontSizeToFitWidth = true
        }
    }
    
    /* Activity Indicator */
    @IBOutlet weak var loadingView: UIActivityIndicatorView!
    {
        didSet
        {
            loadingView.hidesWhenStopped = true
        }
    }
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        view.isUserInteractionEnabled = false
        scrollView.frame = view.bounds
        
        //Sets stack, navbar, and permissions bar each at 1/10th of the view display
        stack.frame = CGRect.init(x: 0, y: 9 * self.view.bounds.height/10, width: self.view.bounds.width, height: self.view.bounds.height/10)
        permissionsBar.frame = CGRect.init(x: 0, y: self.view.bounds.height/10, width: self.view.bounds.width, height: self.view.bounds.height/10)
        navBar.frame = CGRect.init(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height/10)
        deleteAndInfoBar.frame = CGRect.init(x: 0, y: 0, width: 9 * self.view.bounds.width, height: self.view.bounds.height/10)
        
        //Sets up the map image
        mapImage = UIImageView(image: UIImage.init(named: "MapTemplate"))
        
        //Sets up the scroll view
        scrollView.contentSize = mapImage.bounds.size
        scrollView.delegate = self
        scrollView.addSubview(mapImage)
        
        //Adds gesture recognizer and repositions map to correct view
        mapImage.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(tap)))
        enableZoom()
        loadingView.startAnimating()
        
        //HTTP Request to retrieve map and booth information
        let ipAddress = "http://130.65.159.80/RetrieveMap.php"
        let url = URL(string: ipAddress)
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        
        let postString = "eventID=\(selectedLocation!.event_id!)"
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
                            let map = parseJSON["map"] as! [String: Any]
                            let booths = parseJSON["booths"] as! [[String: Any]]
                            
                            for booth in booths
                            {
                                let newButton: BoothShape = BoothShape.init(CGPoint.init(x: CGFloat(Float(booth["location_x"] as! String)!), y: CGFloat(Float(booth["location_y"] as! String)!)), CGSize.init(width: CGFloat(Float(booth["width"] as! String)!), height: CGFloat(Float(booth["height"] as! String)!)), booth["shape"] as! String, booth["color"] as! String, Int(booth["booth_id"] as! String)!, booth["username"] as! String)
                                newButton.draw(self.mapImage.bounds)
                                self.mapImage.addSubview(newButton.button)
                                self.booths.append(newButton)
                            }
                            self.mapName.title = map["event_name"] as? String
                            self.view.isUserInteractionEnabled = true
                            self.loadingView.stopAnimating()
                        }
                    }
                }
                catch let error as Error?
                {
                    print("Found an error - \(String(describing: error))")
                    self.view.isUserInteractionEnabled = true
                    self.loadingView.stopAnimating()
                }
                
        }).resume()
        view.addSubview(scrollView)
        view.addSubview(loadingView)
    }
    
    override func viewWillLayoutSubviews()
    {
        enableZoom()
        super.viewWillLayoutSubviews()
    }
    
    func disableZoom()
    {
        let scale = scrollView.zoomScale
        scrollView.minimumZoomScale = scale
        scrollView.maximumZoomScale = scale
    }
    
    /*
     
    */
    func viewForZooming(in scrollView: UIScrollView) -> UIView?
    {
        return mapImage
    }
    
    /*
     Toggles on and off interaction with the map
    */
    func tap(gesture: UITapGestureRecognizer)
    {
        if(shapeSelected == true)
        {
            shapeSelected = false
            createBooth(gesture.location(in: self.scrollView), "square")
        }
        permissionsText.text = ""
        permissionsText.isEnabled = false
        disableBooths()
        scrollView.isScrollEnabled = true
        enableZoom()
    }
    
    /*
     Determines the minimum scale and maximum scale for zooming. Minimum scale is the smallest scale that fits the entire width or height of the image.
    */
    func enableZoom()
    {
        let mapImageSize = mapImage.bounds.size
        let scrollViewSize = scrollView.bounds.size
        let widthScale = scrollViewSize.width / mapImageSize.width //scale where the width fits the screen
        let heightScale = scrollViewSize.height / mapImageSize.height //scale where the height fits the screen
        
        scrollView.minimumZoomScale = min(widthScale, heightScale) //finds the minimum scale between width and height
        scrollView.maximumZoomScale = 8 * min(widthScale, heightScale) //equivalent to 8x zoom
    }
    
    /*
     Function that controls the zooming of the scroll view
    */
    func scrollViewDidZoom(_ scrollView: UIScrollView)
    {
        let mapImageSize = mapImage.frame.size
        let scrollViewSize = scrollView.bounds.size
        
        let verticalPadding = mapImageSize.height < scrollViewSize.height ? (scrollViewSize.height - mapImageSize.height) / 2 : 0
        let horizontalPadding = mapImageSize.width < scrollViewSize.width ? (scrollViewSize.width - mapImageSize.width) / 2 : 0
        if(verticalPadding == 0 || horizontalPadding == 0)
        {
            scrollView.contentInset = UIEdgeInsets(top: verticalPadding, left: horizontalPadding, bottom: verticalPadding, right: horizontalPadding)
        }
        else
        {
            if(verticalPadding > horizontalPadding)
            {
                scrollView.contentInset = UIEdgeInsets(top: verticalPadding - horizontalPadding, left: 0, bottom: verticalPadding - horizontalPadding, right: 0)
            }
            else if(horizontalPadding > verticalPadding)
            {
                scrollView.contentInset = UIEdgeInsets(top: 0, left: horizontalPadding - verticalPadding, bottom: 0, right: horizontalPadding + verticalPadding)
            }
            else
            {
                scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0) //equal padding ratio
            }
        }
    }
    
    /*
    Creates a booth
    */
    func createBooth(_ point: CGPoint, _ shape: String)
    {
        self.view.isUserInteractionEnabled = false
        let location_x = point.x/scrollView.zoomScale
        let location_y = point.y/scrollView.zoomScale
        loadingView.startAnimating()
        
        //Retrieves ID Number
        let ipAddress = "http://130.65.159.80/RetrieveBoothID.php"
        let url = URL(string: ipAddress)
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        let postString = "event_id=\(selectedLocation?.event_id!))&username=\(UserDefaults.standard.string(forKey: "username")!)&location_x=\(location_x)&location_y=\(location_y)&width=50&height=50&shape=square&color=white"
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
                    let resultValue = parseJSON["status"] as! String
                    print("result: \(resultValue)\n")
                    
                    if(resultValue == "success")
                    {
                        let idNumberString = parseJSON["message"] as! Int
                        let newButton: BoothShape = BoothShape.init(CGPoint.init(x: point.x/self.scrollView.zoomScale, y: point.y/self.scrollView.zoomScale), CGSize.init(width: 50, height: 50), shape, "white", idNumberString, UserDefaults.standard.string(forKey: "username")!)
                        newButton.draw(self.mapImage.bounds)
                        self.mapImage.addSubview(newButton.button)
                        self.booths.append(newButton)
                        self.currentBooth = newButton
                        self.lastBooth = self.currentBooth
                        self.undoButton.isEnabled = true
                        self.view.isUserInteractionEnabled = true
                    }
                    self.loadingView.stopAnimating()
                }
            }
            catch let error as Error?
            {
                print("Found an error - \(String(describing: error))")
                self.view.isUserInteractionEnabled = true
                self.loadingView.stopAnimating()
            }
        }).resume()
    }
    
    /*
    Toggles shape on and off
    */
    func turnOnShape()
    {
        shapeSelected = true
    }
    
    /*
    The undo function
    */
    func undo()
    {
        if(undoButton.isEnabled == true)
        {
            undoButton.isEnabled = false
            for booth in booths
            {
                if(currentBooth != nil && lastBooth == nil) //Undoing a create booth
                {
                    if(booth.equals(currentBooth!))
                    {
                        currentBooth!.button.removeFromSuperview()
                        booths = booths.filter{$0.button != booth.button}
                        currentBooth = nil
                        permissionsText.text = ""
                        permissionsText.isEnabled = false
                    }
                }
                else if(lastBooth != nil && currentBooth == nil) //Undoing a delete booth
                {
                    if(booth.equals(lastBooth!))
                    {
                        lastBooth!.draw(mapImage.bounds)
                        mapImage.addSubview(lastBooth!.button)
                        disableBooths()
                        enableBooth(lastBooth!)
                        booths.append(lastBooth!)
                        permissionsText.text = lastBooth!.user
                        permissionsText.isEnabled = true
                        lastBooth = nil
                    }
                }
                else if(lastBooth != nil && currentBooth != nil) //Undoing other function
                {
                    currentBooth!.button.removeFromSuperview()
                    booths = booths.filter{$0.button != booth.button}
                    currentBooth = nil
                    lastBooth!.draw(mapImage.bounds)
                    mapImage.addSubview(lastBooth!.button)
                    disableBooths()
                    enableBooth(lastBooth!)
                    booths.append(lastBooth!)
                    permissionsText.text = lastBooth!.user
                    permissionsText.isEnabled = true
                    lastBooth = nil
                }
            }
        }
    }
    /*
     Turns off all gesture recognizers for booths except for tap
    */
    func disableBooths()
    {
        for booth in booths
        {
            booth.zoom.isEnabled = false
            booth.move.isEnabled = false
        }
    }
    
    /*
     Enables gesture recognizers for one booth
    */
    func enableBooth(_ booth: BoothShape)
    {
        booth.zoom.isEnabled = true
        booth.move.isEnabled = true
    }
    
    @IBAction func backPressed(_ sender: UIButton)
    {
        self.dismiss(animated: true, completion: nil)
    }
    
    /*
     Saves map to the database
    */
    func save()
    {
        let ipAddress = "http://130.65.159.80/SaveMap.php"
        let url = URL(string: ipAddress)
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        loadingView.startAnimating()
        var boothsJSON: [String:[String: Any]] = [:]
        for booth in booths
        {
            boothsJSON["\(booth.id)"] = ["username": booth.user, "location_x": booth.origin.x, "location_y": booth.origin.y, "shape": booth.geometry, "color": booth.col, "width": booth.rectangle.width, "height": booth.rectangle.height]
        }
        let post = ["mapID": "\(selectedLocation?.event_id!)", "user": "\(UserDefaults.standard.string(forKey: "username"))", "booths": boothsJSON] as [String : Any]
        request.httpBody = try! JSONSerialization.data(withJSONObject: post, options: [])
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
                        self.loadingView.stopAnimating()
                        
                        DispatchQueue.main.async
                        {
                            self.displaySaveAlert(messageToDisplay!)
                        }
                    }
                }
                catch let error as Error?
                {
                    print("Found an error - \(String(describing: error))")
                    self.loadingView.stopAnimating()
                }
                
        }).resume()
    }
    
    func shapeButtonPressed()
    {
        changeShapeButtonPressed = true
    }
    
    func colorButtonPressed()
    {
        changeColorButtonPressed = true
    }
    
    func changePermissions(_ gesture: UITapGestureRecognizer)
    {
        if(permissionsText.text == "" || permissionsText.text == "null")
        {
            DispatchQueue.main.async
            {
                self.displayChangeAlert("No booth is selected to make a change.")
            }
        }
        else
        {
            let oldPermissionsText = currentBooth!.user
            if(oldPermissionsText != permissionsText.text)
            {
                let ipAddress = "http://130.65.159.80/SavePermissions.php"
                let url = URL(string: ipAddress)
                var request = URLRequest(url: url!)
                request.httpMethod = "POST"
                let postString = "newPermissionsText=\(permissionsText.text!)&boothID=\(currentBooth!.id)"
                print(postString)
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
                                let resultValue = parseJSON["status"] as! String!
                                print("result: \(resultValue)\n")
                                let messageToDisplay = parseJSON["message"] as! String!
                                
                                DispatchQueue.main.async
                                {
                                    self.displayChangeAlert(messageToDisplay!)
                                }
                                self.currentBooth!.user = self.permissionsText.text!
                                for booth in self.booths
                                {
                                    if(booth.id == self.currentBooth!.id)
                                    {
                                         booth.user = self.permissionsText.text!
                                    }
                                }
                            }
                        }
                        catch let error as Error?
                        {
                            print("Found an error - \(String(describing: error))")
                            DispatchQueue.main.async
                            {
                                self.displayChangeAlert("User does not exist.")
                            }
                        }
                        
                }).resume()
            }
        }
    }
    
    func enableDeleteBooth(_ gesture: UITapGestureRecognizer)
    {
        deleteButtonPressed = true
    }
    
    func confirm()
    {
        if currentBooth != nil
        {
            displayDeleteAlert()
        }
        else
        {
            displayChangeAlert("No booth is selected to be deleted")
        }
    }
    
    private func displaySaveAlert(_ message: String)
    {
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: UIAlertControllerStyle.alert)
        let ok = UIAlertAction(title: "OK", style: UIAlertActionStyle.default)
        {
            (action:UIAlertAction) in
            let rootVC = UIApplication.shared.keyWindow?.rootViewController
            let tabBarController = rootVC!.storyboard!.instantiateViewController(withIdentifier: "TabBarController") as! TabBarController
            self.present(tabBarController, animated: true, completion: nil)
        }
        alert.addAction(ok)
        self.present(alert, animated: true, completion: nil)
    }
    
    private func displayChangeAlert(_ message: String)
    {
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: UIAlertControllerStyle.alert)
        let ok = UIAlertAction(title: "OK", style: UIAlertActionStyle.default)
        alert.addAction(ok)
        self.present(alert, animated: true, completion: nil)
    }
    
    private func displayDeleteAlert()
    {
        let alert = UIAlertController(title: "Alert", message: "Are you sure you want to delete this booth?", preferredStyle: UIAlertControllerStyle.alert)
        let ok = UIAlertAction(title: "OK", style: UIAlertActionStyle.default)
        {
            (action:UIAlertAction) in
            self.deleteFromMap()
        }
        let cancel = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default)
        {
            (action:UIAlertAction) in
            self.deleteButtonPressed = false
        }
        alert.addAction(cancel)
        alert.addAction(ok)
        self.present(alert, animated: true, completion: nil)
    }
    
    private func deleteFromMap()
    {
        view.isUserInteractionEnabled = false
        loadingView.startAnimating()
        let ipAddress = "http://130.65.159.80/DeleteBooth.php"
        let url = URL(string: ipAddress)
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        let postString = "boothID=\(currentBooth!.id)"
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
                        let resultValue = parseJSON["status"] as! String!
                        print("result: \(resultValue)\n")
                        let messageToDisplay = parseJSON["message"] as! String!
                        
                        DispatchQueue.main.async
                        {
                            self.displayChangeAlert(messageToDisplay!)
                        }
                        self.lastBooth = nil
                        //remove from superview
                        self.currentBooth!.button.removeFromSuperview()
                        //remove from booth array list
                        self.booths = self.booths.filter {!$0.equals(self.currentBooth!)}
                        self.currentBooth = nil
                        self.loadingView.stopAnimating()
                        self.view.isUserInteractionEnabled = true
                    }
                }
                catch let error as Error?
                {
                    print("Found an error - \(String(describing: error))")
                    DispatchQueue.main.async
                    {
                        self.displayChangeAlert("Was not able to delete booth.")
                    }
                    self.loadingView.stopAnimating()
                    self.view.isUserInteractionEnabled = true
                }
                
        }).resume()
    }
    
        /*
        Triggers the popover
         */
        func popOver(_ sender: AnyObject)
        {
            /* This is the line of code that calls the 'prepareforSegue' method */
            //performSegue(withIdentifier: "editBoothPopover", sender: sender)
    
//            let castedSender : BoothShape = sender as! BoothShape
    
            //print(sender.name)
            /* This is the line of code that calls the 'prepareforSegue' method,but we are not using it */
            //performSegue(withIdentifier: "editBoothPopover", sender: sender)
            //print(castedSender.name + " Here!")
    
    
    
            let rootVC = UIApplication.shared.keyWindow?.rootViewController
    
            //print(NSStringFromClass(rootVC!.classForCoder))
    
    
            //let strBoard = UIStoryboard(name: "Main", bundle: nil)
            let popoverController = rootVC!.storyboard!.instantiateViewController(withIdentifier: "CreateMapViewController") as! CreateMapViewController
            popoverController.selectedLocation = LocationModel()
            popoverController.selectedLocation?.event_id = self.selectedLocation?.event_id
    
    
            //get a reference to the view controller for the popover
//            popoverController.boothRef = castedSender //as? BoothShape
//            popoverController.name = castedSender.name
//            popoverController.info = castedSender.info
//            popoverController.date = castedSender.date
//            popoverController.boothImages = castedSender.boothPhotos
//            popoverController.delegate = self
    
            // set the presentation style
            popoverController.modalPresentationStyle = UIModalPresentationStyle.popover
    
            // set up the popover presentation controller
            popoverController.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection.any
//            popoverController.popoverPresentationController?.delegate = self
//            popoverController.popoverPresentationController?.sourceView = castedSender.button
    
            // set anchor programatically
//            popoverController.popoverPresentationController?.sourceRect = castedSender.button.bounds
            
            // present the popover
            self.present(popoverController, animated: true, completion: nil)
        }

}

