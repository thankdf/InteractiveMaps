//
//  AttendeeMapViewController.swift
//  Skeye
//
//  Created by Kevin Dang on 4/28/17.
//  
//

import UIKit

class AttendeeMapViewController: UIViewController, UIScrollViewDelegate, UIPopoverPresentationControllerDelegate, DataSentDelegate
{
     var selectedLocation : LocationModel?
    
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
    internal func userDidEditStartTime(data: String, whichBooth: BoothShape) {
        whichBooth.startTime = data
    }
    internal func userDidEditEndTime(data: String, whichBooth: BoothShape) {
        whichBooth.endTime = data
    }
    internal func userDidEditAbbrev(data: String, whichBooth: BoothShape) {
        whichBooth.abbrev = data
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
    
    /* Objects obtained from the database */
    var booths: [BoothShape] = [BoothShape]() //list of booths
    
    /* Gesture recognizers */
    var select: UITapGestureRecognizer = UITapGestureRecognizer.init()
    
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
        
        //Sets navbar bar each at 1/10th of the view display
        navBar.frame = CGRect.init(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height/10)
        
        //Sets up the map image
        mapImage = UIImageView(image: UIImage.init(named: "MapTemplate"))
       
        
         //Sets up the scroll view
        scrollView.contentSize = mapImage.bounds.size
        scrollView.delegate = self
        scrollView.addSubview(mapImage)
        
        //Repositions map to correct view
        enableZoom()
        //loadingView.startAnimating()
        
        //HTTP Request to retrieve map and booth information
        let ipAddress = "http://130.65.159.80/RetrieveMap.php"
        let url = URL(string: ipAddress)
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"


        let postString = "eventID=\((selectedLocation?.event_id!)!)"
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
                        let map = parseJSON["map"] as! [String: Any]
                        let booths = parseJSON["booths"] as! [[String: Any]]
                        DispatchQueue.main.async(){
                                                   for booth in booths
                        {
                            let newButton: BoothShape = BoothShape.init(CGPoint.init(x: CGFloat(Float(booth["location_x"] as! String)!), y: CGFloat(Float(booth["location_y"] as! String)!)), CGSize.init(width: CGFloat(Float(booth["width"] as! String)!), height: CGFloat(Float(booth["height"] as! String)!)), booth["shape"] as! String, booth["color"] as! String, Int(booth["booth_id"] as! String)!, booth["username"] as! String)
                            newButton.draw(self.mapImage.bounds)
                            
                            
                            self.mapImage.addSubview(newButton.button)
                            self.booths.append(newButton)
                        }
                        self.mapName.title = map["event_name"] as? String
                        self.view.isUserInteractionEnabled = true
                        //self.loadingView.stopAnimating()
                        }
                    }
                }
                catch let error as Error?
                {
                    print("Found an error - \(String(describing: error))")
                    self.view.isUserInteractionEnabled = true
                    //self.loadingView.stopAnimating()
                }
                
        }).resume()
        
        view.addSubview(scrollView)
        //view.addSubview(loadingView)
    }
    @IBOutlet weak var mapName: UINavigationItem!
    {
        didSet
        {
            mapName.title = "Title"
        }
    }
    
    override func viewWillLayoutSubviews()
    {
        enableZoom()
        super.viewWillLayoutSubviews()
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
        
        popoverController.selectedLocation = LocationModel()
        popoverController.selectedLocation.booth_id = selectedLocation!.booth_id
        
        //get a reference to the view controller for the popover
        popoverController.boothRef = castedSender //as? BoothShape
        popoverController.name = castedSender.name
        popoverController.info = castedSender.info
        popoverController.startTime = castedSender.startTime
        popoverController.endTime = castedSender.endTime
        popoverController.abbreviation = castedSender.abbrev
        popoverController.boothImages = castedSender.boothPhotos
        popoverController.delegate = self
        
        // set the presentation style
        //popoverController.modalPresentationStyle = UIModalPresentationStyle.popover
        
        // set up the popover presentation controller
        popoverController.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection.any
        popoverController.popoverPresentationController?.delegate = self
        popoverController.popoverPresentationController?.sourceView = castedSender.button
        
        // set anchor programatically
        popoverController.popoverPresentationController?.sourceRect = castedSender.button.bounds
        
        // present the popover
        self.present(popoverController, animated: true, completion: nil)
    }
    
    
    
    
    @IBAction func backPressed(_ sender: UIButton)
    {
        self.dismiss(animated: true, completion: nil)
//        self.present(searchController, animated: true, completion: nil)
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
