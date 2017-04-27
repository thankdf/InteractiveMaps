//
//  ViewController.swift
//  Skeye
//
//  Created by Kevin Dang on 2/6/17.
//  Copyright © 2017 Team_Skeye. All rights reserved.
//

import UIKit

class MapViewController: UIViewController, UIScrollViewDelegate, UIPopoverPresentationControllerDelegate, DataSentDelegate
{
    /* Delegate-related: mainVC implement protocal fucntion*/
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

    
    /* Map Boundaries */
    @IBOutlet weak var scrollView: UIScrollView!
    {
        didSet
        {
            scrollView.backgroundColor = UIColor.white
            scrollView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        }
    }
    
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
    
    /* Booleans */
    var shapeSelected = false //if user selected a shape before tapping on the screen
    
    /* Objects obtained from the database */
    var booths: [BoothShape] = [BoothShape]() //list of booths

    /* Gesture recognizers */
    var select: UITapGestureRecognizer = UITapGestureRecognizer.init()
    
    /* For Undo function */
    var lastBooth: BoothShape? = nil
    var currentBooth: BoothShape? = nil
    
    /* Map Variables */
    var mapID: Int = 1
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        scrollView.frame = view.bounds
        stack.frame = CGRect.init(x: 0, y: 9 * self.view.bounds.height/10, width: self.view.bounds.width, height: self.view.bounds.height/10)
        navBar.frame = CGRect.init(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height/10)
        mapImage = UIImageView(image: UIImage.init(named: "MapTemplate"))
        scrollView.contentSize = mapImage.bounds.size
        scrollView.delegate = self
        scrollView.addSubview(mapImage)
        mapImage.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(tap)))
        enableZoom()
        
        let ipAddress = "http://130.65.159.80/RetrieveMap.php"
        let url = URL(string: ipAddress)
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        
        let postString = "eventID=\(mapID)"
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
                        let value = parseJSON["map"] as! String
                        print(value)
                    }
                }
                catch let error as Error?
                {
                    print("Found an error - \(String(describing: error))")
                }
                
        }).resume()

        
        for booth in booths
        {
            booth.draw(mapImage.bounds)
            mapImage.addSubview(booth.button)
        }
        view.addSubview(scrollView)
    }
    
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
        }
    }
    
    @IBOutlet weak var colorButton: UIButton!
    {
        didSet
        {
            colorButton.titleLabel?.adjustsFontSizeToFitWidth = true
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
            createBooth(gesture.location(in: self.scrollView), "circle")
        }
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
    Triggers the popover
     */
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
    
    /*
    Creates a booth
    */
    func createBooth(_ point: CGPoint, _ shape: String)
    {
        self.view.isUserInteractionEnabled = false
        let location_x = point.x/scrollView.zoomScale
        let location_y = point.y/scrollView.zoomScale
        
        let newButton: BoothShape = BoothShape.init(CGPoint.init(x: point.x/self.scrollView.zoomScale, y: point.y/self.scrollView.zoomScale), CGSize.init(width: 50, height: 50), shape, "white", 1, "hk.at.dang@gmail.com")
        newButton.draw(self.mapImage.bounds)
        self.mapImage.addSubview(newButton.button)
        
        //Retrieves ID Number
        let ipAddress = "http://130.65.159.80/RetrieveBoothID.php"
        let url = URL(string: ipAddress)
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        let postString = "event_id=\(mapID)&user=hk.at.dang@gmail.com&location_x=\(location_x)&location_y=\(location_y)&width=50&height=50&shape=\(shape)&color=white"
//        let postString = "event_id=\(mapID)&user=\(UserDefaults.standard.string(forKey: "username"))&location_x=\(location_x)&location_y=\(location_y)&width=50&height=50&shape=\(shape)&color=white"
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
                var id = 1
                let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? NSDictionary
                if let parseJSON = json
                {
                    let resultValue: String = parseJSON["status"] as! String
                    print("result: \(resultValue)\n")
                    
                    if(resultValue == "success")
                    {
                        let idNumberString = parseJSON["message"] as! String
                        id = Int(idNumberString)!
//                                let newButton: BoothShape = BoothShape.init(CGPoint.init(x: point.x/self.scrollView.zoomScale, y: point.y/self.scrollView.zoomScale), CGSize.init(width: 50, height: 50), shape, "white", id, UserDefaults.standard.string(forKey: "username")!)
                        newButton.id = id
                        self.booths.append(newButton)
                        self.currentBooth = newButton
                        self.lastBooth = nil
                        self.undoButton.isEnabled = true
                        self.view.isUserInteractionEnabled = true
                    }
                }
            }
            catch let error as Error?
            {
                print("Found an error - \(String(describing: error))")
                self.view.isUserInteractionEnabled = true
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
                if(currentBooth != nil && lastBooth == nil) //undoing a create booth
                {
                    if(booth.equals(currentBooth!))
                    {
                        currentBooth!.button.removeFromSuperview()
                        booths = booths.filter{$0.button != booth.button}
                        currentBooth = nil
                    }
                }
                else if(lastBooth != nil && currentBooth == nil) //undoing a delete booth
                {
                    if(booth.equals(lastBooth!))
                    {
                        lastBooth!.draw(mapImage.bounds)
                        mapImage.addSubview(lastBooth!.button)
                        disableBooths()
                        enableBooth(lastBooth!)
                        booths.append(lastBooth!)
                        lastBooth = nil
                    }
                }
                else if(lastBooth != nil && currentBooth != nil) //undoing other function
                {
                    currentBooth!.button.removeFromSuperview()
                    booths = booths.filter{$0.button != booth.button}
                    currentBooth = nil
                    lastBooth!.draw(mapImage.bounds)
                    mapImage.addSubview(lastBooth!.button)
                    disableBooths()
                    enableBooth(lastBooth!)
                    booths.append(lastBooth!)
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
        let rootVC = UIApplication.shared.keyWindow?.rootViewController
        let searchController = rootVC!.storyboard!.instantiateViewController(withIdentifier: "NavigationController")
        
        self.present(searchController, animated: true, completion: nil)
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
        var boothsJSON = "["
        for booth in booths
        {
            let boothArray: Dictionary<String, Any> = ["username": booth.user, "location_x": booth.origin.x, "location_y": booth.origin.y, "shape": booth.geometry, "color": booth.col, "width": booth.rectangle.width, "height": booth.rectangle.height]
            let boothArrayJSON = try! JSONSerialization.data(withJSONObject: boothArray, options: [])
            boothsJSON += "\(booth.id): \(boothArrayJSON), "
        }
        if(boothsJSON != "[")
        {
            boothsJSON = boothsJSON.substring(to: boothsJSON.index(boothsJSON.endIndex, offsetBy: -2)) + "]"
        }
        else
        {
            boothsJSON = ""
        }
        let post = ["mapID": "\(mapID)", "user": "hk.at.dang@gmail.com", "booths": boothsJSON] as [String : Any]
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
                        
                        DispatchQueue.main.async
                        {
                            self.displayAlert(messageToDisplay!)
                        }
                        
                    }
                }
                catch let error as Error?
                {
                    print("Found an error - \(String(describing: error))")
                }
                
        }).resume()
    }
    
    private func displayAlert(_ message: String)
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
}

