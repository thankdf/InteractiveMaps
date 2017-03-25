//
//  ViewController.swift
//  Skeye
//
//  Created by Kevin Dang on 2/6/17.
//  Copyright © 2017 Team_Parking. All rights reserved.
//

import UIKit

class MapViewController: UIViewController, UIScrollViewDelegate, UIPopoverPresentationControllerDelegate, DataSentDelegate
{
    /* Delegate Comment: mainVC implement protocal fucntion*/
    internal func userDidEditInfo(data: String, whichBooth: BoothShape)
    {
        whichBooth.info = data
    }
    internal func userDidEditName(data: String, whichBooth: BoothShape)
    {
        whichBooth.name = data
        
    }
    internal func userDidUploadPic(data: UIImage, whichBooth: BoothShape)
    {
        whichBooth.image = data
    }
    
    /* Map Boundaries */
    @IBOutlet weak var scrollView: UIScrollView!
    {
        didSet
        {
            scrollView.backgroundColor = UIColor.black
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
    
    /* Adjust size for stack at the bottom */
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
    
    @IBOutlet weak var undoButton: UIButton!
    {
        didSet
        {
            undoButton.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(undo)))
            undoButton.isEnabled = false
        }
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        scrollView.frame = view.bounds
        mapImage = UIImageView(image: UIImage.init(named: "Testing"))
        scrollView.contentSize = mapImage.bounds.size
        scrollView.delegate = self
        scrollView.addSubview(mapImage)
        mapImage.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(tap)))
        enableZoom()
        for booth in booths
        {
            booth.draw(mapImage.bounds)
            mapImage.addSubview(booth.button)
        }
        scrollViewDidZoom(scrollView) //readjusts image to correct aspect ratio
        view.addSubview(scrollView)
         stack.frame = CGRect.init(x: 0, y: 9 * self.view.bounds.height/10, width: self.view.bounds.width, height: self.view.bounds.height/10)
    }
    
   
    @IBOutlet weak var boothButton: UIButton!
    {
        didSet
        {
            boothButton.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(turnOnShape)))
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
        
        if let castedSender: BoothShape = sender as? BoothShape
        {
            let popoverController = storyboard?.instantiateViewController(withIdentifier: "EditBoothOrganizerViewController") as! EditBoothOrganizerViewController
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
        let newButton: BoothShape = BoothShape.init(CGPoint.init(x: point.x/scrollView.zoomScale, y: point.y/scrollView.zoomScale), CGSize.init(width: 50, height: 50), shape, "white")
        newButton.draw(mapImage.bounds)
        mapImage.addSubview(newButton.button)
        booths.append(newButton)
        currentBooth = newButton
        lastBooth = nil
        undoButton.isEnabled = true
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
            booth.press.isEnabled = false
        }
    }
    
    /*
     Enables gesture recognizers for one booth
    */
    func enableBooth(_ booth: BoothShape)
    {
        booth.zoom.isEnabled = true
        booth.move.isEnabled = true
        booth.press.isEnabled = true
    }
}

