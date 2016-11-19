//
//  ViewController.swift
//  Maps
//
//  Created by Kevin Dang on 10/15/16.
//  Copyright © 2016 Team_Interactive_Maps. All rights reserved.
//

import UIKit

class MapViewController: UIViewController {

    var viewGap: CGFloat = 5
    var minimumBoothArea: CGFloat = 2500
    var buttonSize: CGSize = CGSize.init(width: 50, height: 50)
    var booths: [BoothProperties] = [BoothProperties]() //booths to be implemented
    var selectedBoothShape: String = ""
    @IBOutlet weak var boothView: BoothProperties!
    {
        didSet
        {
            boothView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(selectBooth)))
            boothView.addGestureRecognizer(UIRotationGestureRecognizer(target: self, action: #selector(rotate)))
            boothView.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(translatePosition)))
            boothView.addGestureRecognizer(UIPinchGestureRecognizer(target: self, action: #selector(changeDimensions)))
            boothView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(selectBooth)))
            boothView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(addBooth)))
        }
    }
    @IBOutlet weak var shapeView: UIScrollView!
    {
        didSet
        {
            shapeView.contentSize = CGSize.init(width: 500, height: shapeView.contentSize.height)
        }
    }
    @IBOutlet weak var buttonView: UIScrollView!
    {
        didSet
        {
            buttonView.contentSize = CGSize.init(width: 500, height:buttonView.contentSize.height)
        }
    }
    /*
     Change shape to current shape selected
    */
    @IBAction func selectNewShape(button: UIButton)
    {
        if let newShape = button.titleLabel?.text
        {
            selectedBoothShape = newShape
            print(selectedBoothShape)
        }
    }
    
    /*
     Adds booth to the view
    */
    @IBAction func addBooth(gesture: UITapGestureRecognizer) //adds booth
    {
        if selectedBoothShape != ""
        {
            let frame = CGRect.init(origin: CGPoint.init(x: gesture.location(in: boothView).x - buttonSize.width/2, y: gesture.location(in: boothView).y - buttonSize.height/2), size: buttonSize)
            let button = BoothProperties()
            button.setAttributes(newName: "", newID: 0, newInformation: "", newItems: Dictionary<String, Double>(), newPhotos: [UIImage](), newColor: UIColor.white, newShape: selectedBoothShape, newOwnerID: 0, newFrame: frame)
            for booth in booths
            {
                booth.isUserInteractionEnabled = false
            }
            let path: UIBezierPath = UIBezierPath.init(arcCenter: CGPoint.init(x: frame.midX, y: frame.midY), radius: min((CGFloat)(frame.width/2), (CGFloat)(frame.height/2)), startAngle: 0, endAngle: 360, clockwise: true)
            path.stroke()
            button.draw(frame)
            //boothView.addSubview(button)
            booths.append(button)
            selectedBoothShape = "" //resets selected booth shape
        }
    }
    
    /*
     Moves selected booth around
    */
    @IBAction func translatePosition(gesture: UIPanGestureRecognizer)
    {
        if let booth = determineBooth()
        {
            if (booth.frame.contains(gesture.location(in: boothView)))
            {
                let point = CGPoint.init(x: gesture.location(in: boothView).x - booth.frame.width/2, y: gesture.location(in: boothView).y - booth.frame.height/2)
                if(boothView.bounds.contains(point) && boothView.bounds.width - viewGap >= point.x + booth.bounds.width && point.x >= viewGap && boothView.bounds.height - viewGap >= point.y + booth.bounds.height && point.y >= viewGap) //if booth is within bounds
                {
                    booth.frame.origin = point
                    gesture.setTranslation(CGPoint.zero, in: boothView)
                }
            }
        }
    }
    
    /*
     Selects booth that user is pressing on to be manipulated
    */
    @IBAction func selectBooth(gesture: UITapGestureRecognizer)
    {
        for booth in booths
        {
            if booth.frame.contains(gesture.location(in: boothView))
            {
                booth.isUserInteractionEnabled = true
            }
            else
            {
                booth.isUserInteractionEnabled = false
            }
        }
    }
    
    /*
    Deletes booth that is currently selected
    */
    func deleteBooth()
    {
        var done = false
        for i: Int in 0 ..< booths.count where !done
        {
            if booths[i].isUserInteractionEnabled
            {
                let removed = booths.remove(at: i)
                removed.removeFromSuperview()
                done = true
            }
        }
    }
    
    /*
     Zooming Function
     */
    func changeDimensions(gesture: UIPinchGestureRecognizer)
    {
        if gesture.state == .changed
        {
            if let booth = determineBooth()
            {
                //creates new rectangle that shows translation of zooming in or out with center as reference point
                let rect = CGRect.init(origin: CGPoint.init(x: booth.frame.origin.x + (1-gesture.scale)*booth.bounds.width/2,
                    y: booth.frame.origin.y + (1-gesture.scale)*booth.bounds.height/2), size: CGSize.init(width: booth.frame.width * gesture.scale, height: booth.bounds.height * gesture.scale))
                //if the booth's area is greater than minimum booth size to prevent small-scale zooming and the bounds are within the viewgap
                if ((boothView.bounds.maxX - viewGap >= rect.maxX * gesture.scale) && (boothView.bounds.minX + viewGap <= rect.minX * gesture.scale)
                    && (boothView.bounds.maxY - viewGap >= rect.maxY * gesture.scale) && (boothView.bounds.minY + viewGap <= rect.minY * gesture.scale) && (rect.width*rect.height > minimumBoothArea))
                {
                    booth.frame = rect
                    //reset the scale of the gesture
                    gesture.scale = 1
                }
            }
        }
    }

    /*
    Function that handles buttons pressed
    */
    @IBAction func buttonPressed(sender: UIButton)
    {
        if let title = sender.titleLabel!.text
        {
            switch(title)
            {
            case("Add Booth"):
                boothView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(addBooth)))
            case("Select Booth"):
                boothView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(selectBooth)))
            case("Delete Booth"):
                deleteBooth()
            case("Enable Zoom"):
                boothView.addGestureRecognizer(UIPinchGestureRecognizer(target: self, action: #selector(changeDimensions)))
            case("Enable Move Booth"):
                boothView.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(translatePosition)))
            case("Enable Rotation"):
                boothView.addGestureRecognizer(UIRotationGestureRecognizer(target: self, action: #selector(rotate)))
            default: break
            }
        }
    }
    
    /*
     Enables rotation
    */
    func rotate(gesture: UIRotationGestureRecognizer)
    {
        var lastRotation = CGFloat()
        if gesture.state == .changed
        {
            if let booth = determineBooth()
            {
                let rotation = 0.0 - (lastRotation - gesture.rotation)
                booth.transform = (gesture.view?.transform)!.rotated(by: rotation)
                booth.imageView?.transform = booth.transform
                lastRotation = gesture.rotation
                if(gesture.state == UIGestureRecognizerState.ended)
                {
                    lastRotation = 0.0;
                }
            }
        }
    }
    
    /*
     Determines which booth is currently selected
     */
    func determineBooth() -> BoothProperties?
    {
        for booth in booths
        {
            if(booth.isUserInteractionEnabled)
            {
                return booth
            }
        }
        return nil
    }
}

