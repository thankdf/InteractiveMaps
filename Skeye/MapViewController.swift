//
//  ViewController.swift
//  Skeye
//
//  Created by Kevin Dang on 2/6/17.
//  Copyright © 2017 Team_Parking. All rights reserved.
//

import UIKit

class MapViewController: UIViewController, UIPopoverPresentationControllerDelegate, DataSentDelegate
{
    /* Delegate Comment: mainVC implement protocal fucntion*/
    internal func userDidEditInfo(data: String, whichBooth: BoothShape) {
        whichBooth.info = data
    }
    internal func userDidEditName(data: String, whichBooth: BoothShape) {
        whichBooth.name = data
        
    }
    internal func userDidUploadPic(data: UIImage, whichBooth: BoothShape){
        whichBooth.image = data
    }
    
    /* Map Boundaries */
    var frameMinimum: CGFloat = 0 //allowed frame boundaries
    var zoomMinimum: CGFloat = 0 //minimum zoom screen size
    
    /* Booleans */
    var shapeSelected = false //if user selected a shape before tapping on the screen
    
    /* Objects obtained from the database */
    var buttons: [BoothShape] = [BoothShape]() //list of booths
    var image: UIImage = UIImage.init(named: "NotefyMe")! //map image

    /* Gesture recognizers */
    var zoom: UIPinchGestureRecognizer = UIPinchGestureRecognizer.init()
    var select: UITapGestureRecognizer = UITapGestureRecognizer.init()
    var move: UIPanGestureRecognizer = UIPanGestureRecognizer.init()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        mapImage.contentScaleFactor = 1
        mapImage.frame = CGRect.init(x: 0, y: 0, width: (image.cgImage?.width)!, height: (image.cgImage?.height)!)
        mapImage.sizeToFit()
    }
    
    
    @IBOutlet weak var shape: UIButton!
    {
        didSet
        {
            shape.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(turnOnShape)))
        }
    }
    
    @IBOutlet weak var color: UIButton!
    {
        didSet
        {
            color.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(turnOnShape)))
        }
    }
    
    @IBOutlet weak var mapImage: UIImageView!
    {
        didSet
        {
            mapImage.image = image
            mapImage.alpha = 0.25
            mapImage.contentScaleFactor = 1
            zoom = UIPinchGestureRecognizer(target: self, action: #selector(pinch))
            mapImage.addGestureRecognizer(zoom)
            select = UITapGestureRecognizer(target: self, action: #selector(tap))
            mapImage.addGestureRecognizer(select)
            move = UIPanGestureRecognizer(target: self, action: #selector(pan))
            mapImage.addGestureRecognizer(move)
        }
    }
    
    /*
     Controls zoom for the map and booths within a specified range
    */
    func pinch(gesture: UIPinchGestureRecognizer)
    {
        if let viewer = gesture.view
        {
            if !(viewer.frame.height < mapImage.frame.width || viewer.frame.width < zoomMinimum && gesture.scale < 1)
            {
                viewer.transform = viewer.transform.scaledBy(x: gesture.scale, y: gesture.scale)
                gesture.scale = 1
            }
        }
    }
    
    /*
     Controls movement for the map and booths within a specified range
     */
    func pan(gesture: UIPanGestureRecognizer)
    {
        let translation = gesture.translation(in: self.view)
        if let viewer = gesture.view
        {
            if !(viewer.frame.maxX + translation.x < 0 || viewer.frame.minX + translation.x > image.size.width || viewer.frame.maxY + translation.y < 0 || viewer.frame.minY + translation.y > image.size.height)
            {
                viewer.center = CGPoint.init(x: viewer.center.x + translation.x, y: viewer.center.y + translation.y)
                gesture.setTranslation(CGPoint.init(x: 0, y: 0), in: self.view)
            }
        }
    }
    
    /*
     Toggles on and off interaction with the map
    */
    func tap(gesture: UITapGestureRecognizer)
    {
        if(shapeSelected == true)
        {
            shapeSelected = false
            createBooth(gesture.location(in: self.mapImage), "circle")
        }
        for gesture in mapImage.gestureRecognizers!
        {
            gesture.isEnabled = true
        }
    }
    
    /*
    Triggers the popover
     */
    func popOver(_ sender: AnyObject)
    {
        /* This is the line of code that calls the 'prepareforSegue' method */
        //performSegue(withIdentifier: "editBoothPopover", sender: sender)
        
        if let castedSender: BoothShape = sender as? BoothShape
        {
            let popoverController = storyboard?.instantiateViewController(withIdentifier: "EditBoothViewController") as! EditBoothViewController
            popoverController.boothRef = castedSender
            popoverController.name = castedSender.name
            popoverController.info = castedSender.info
            popoverController.image = castedSender.image
            popoverController.delegate = self
            
            // set the presentation style
            popoverController.modalPresentationStyle = UIModalPresentationStyle.popover
            
            // set up the popover presentation controller
            popoverController.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection.any
            popoverController.popoverPresentationController?.sourceView = castedSender.button as UIView
            // set anchor programatically
            //        popoverController.popoverPresentationController?.sourceRect = sender.bounds
            
            self.present(popoverController, animated: true, completion: nil)
        }
    }
    
    /*
    Creates a booth
    */
    func createBooth(_ point: CGPoint, _ shape: String)
    {
        let newButton: BoothShape = BoothShape.init(point, CGSize.init(width: 100, height: 100), shape, "red")
        newButton.draw(mapImage.bounds)
        mapImage.addSubview(newButton.button)
        buttons.append(newButton)
    }
    
    /*
    Toggles shape on and off
    */
    func turnOnShape()
    {
        shapeSelected = true
    }
}

