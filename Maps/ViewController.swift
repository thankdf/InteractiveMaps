//
//  ViewController.swift
//  Maps
//
//  Created by Kevin Dang on 10/15/16.
//  Copyright © 2016 Team_Interactive_Maps. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var viewGap: CGFloat = 5
    var minimumBoothArea: CGFloat = 2500
    var booths: [BoothProperties] = [BoothProperties]() //booths to be implemented
    var selectedBoothShape: UIImage? = nil
    @IBOutlet weak var boothView: BoothProperties!
    {
        didSet
        {
            boothView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(selectBooth)))
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
        if let newImage = button.imageView
        {
            selectedBoothShape = newImage.image
        }
    }
    
    /*
     Adds booth to the view
    */
    @IBAction func addBooth(gesture: UITapGestureRecognizer) //adds booth
    {
        resetMode()
        if let _ = selectedBoothShape
        {
            let frame = CGRect.init(origin: CGPoint.init(x: gesture.location(in: boothView).x - (selectedBoothShape?.size.width)!/2, y: gesture.location(in: boothView).y - (selectedBoothShape?.size)!.height/2), size: (selectedBoothShape?.size)!)
            let button = BoothProperties()
            button.frame = frame
            button.setBackgroundImage(selectedBoothShape, for: UIControlState.normal)
            for booth in booths
            {
                booth.isUserInteractionEnabled = false
            }
            boothView.addSubview(button)
            booths.append(button)
            selectedBoothShape = nil //resets selected booth shape
        }
    }
    
    /*
     Moves selected booth around
    */
    @IBAction func translatePosition(gesture: UIPanGestureRecognizer)
    {
        for booth in booths
        {
            if (booth.frame.contains(gesture.location(in: boothView)) && booth.isUserInteractionEnabled)
            {
                let point = CGPoint.init(x: gesture.location(in: boothView).x - booth.frame.width/2, y: gesture.location(in: boothView).y - booth.frame.height/2)
                if(boothView.bounds.contains(point) && boothView.bounds.width - viewGap >= point.x + booth.bounds.width && point.x >= viewGap && boothView.bounds.height - viewGap >= point.y + booth.bounds.height && point.y >= viewGap) //if booth is within bounds
                {
                    booth.frame.origin = point
                }
            }
        }
    }
    
    /*
     Selects booth that user is pressing on to be manipulated
    */
    @IBAction func selectBooth(gesture: UITapGestureRecognizer)
    {
        resetMode()
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
            for booth in booths
            {
                if (booth.isUserInteractionEnabled)
                {
                    //creates new rectangle that shows translation of zooming in or out with center as reference point
                    let rect = CGRect.init(origin: CGPoint.init(x: booth.frame.origin.x + (1-gesture.scale)*booth.bounds.width/2,
                    y: booth.frame.origin.y + (1-gesture.scale)*booth.bounds.height/2), size: CGSize.init(width: booth.frame.width * gesture.scale,
                    height: booth.frame.height * gesture.scale))
                    //if the booth's area is greater than minimum booth size to prevent small-scale zooming and the bounds are within the viewgap
                    if ((boothView.bounds.maxX - viewGap > rect.maxX * gesture.scale) && (boothView.bounds.minX + viewGap < rect.minX * gesture.scale)
                        && (boothView.bounds.maxY - viewGap >= rect.maxY * gesture.scale) && (boothView.bounds.minY + viewGap <= rect.minY * gesture.scale)
                        && (rect.width*rect.height > minimumBoothArea))
                    {
                        booth.frame = rect
                        //reset the scale of the gesture
                        gesture.scale = 1
                    }

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
            resetMode()
            switch(title)
            {
            case("Add Booth"):
                boothView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(addBooth)))
            case("Select Booth"):
                boothView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(selectBooth)))
            case("Delete Booth"):
                deleteBooth()
            case("Zoom"):
                boothView.addGestureRecognizer(UIPinchGestureRecognizer(target: self, action: #selector(changeDimensions)))
            case("Move Booth"):
                boothView.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(translatePosition)))
            default: break
            }
        }
    }
    
    /*
     Resets zoom and move booth functionalities
    */
    func resetMode()
    {
        boothView.removeGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(addBooth)))
        boothView.removeGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(selectBooth)))
        boothView.removeGestureRecognizer(UIPinchGestureRecognizer(target: self, action: #selector(changeDimensions)))
        boothView.removeGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(translatePosition)))
    }
}

