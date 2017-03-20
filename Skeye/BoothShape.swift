//
//  BoothShape.swift
//  Skeye
//
//  Created by Kevin Dang on 2/13/17.
//  Copyright © 2017 Team_Parking. All rights reserved.
//

import UIKit

class BoothShape
{
    var button: UIButton
    var origin: CGPoint
    var rectangle: CGSize
    var geometry: String
    var col: String
    var name: String
    var info: String
    var image: UIImage
    
    //Gesture recognizers
    var zoom: UIPinchGestureRecognizer
    var select: UITapGestureRecognizer
    var move: UIPanGestureRecognizer
    var press: UILongPressGestureRecognizer
    
    init(_ point: CGPoint, _ size: CGSize, _ shape: String, _ color: String)
    {
        origin = point
        rectangle = size
        geometry = shape
        col = color
        button = UIButton()
        zoom = UIPinchGestureRecognizer.init();
        select = UITapGestureRecognizer.init();
        move = UIPanGestureRecognizer.init();
        press = UILongPressGestureRecognizer.init()
        name = "Default name"
        info = "Default info"
        image = UIImage.init()
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
     */
    func draw(_ rect: CGRect)
    {
        button = UIButton.init(frame: CGRect.init(origin: CGPoint.init(x: origin.x - rectangle.width/2, y: origin.y - rectangle.height/2), size: rectangle))
        button.setTitle("Test!", for: UIControlState.normal)
        
        //draws shapes
        switch(geometry)
        {
            case "circle":
                switch(col)
                {
                case("white"):
                    button.setBackgroundImage(UIImage.init(named: "WhiteCircle"), for: UIControlState.normal)
                case("red"):
                    button.setBackgroundImage(UIImage.init(named: "RedCircle"), for: UIControlState.normal)
                case("yellow"):
                    button.setBackgroundImage(UIImage.init(named: "YellowCircle"), for: UIControlState.normal)
                case("blue"):
                    button.setBackgroundImage(UIImage.init(named: "BlueCircle"), for: UIControlState.normal)
                default: break
                }
            default: break
        }
        
        //initializes gesture recognizers
        zoom = UIPinchGestureRecognizer.init(target: self, action: #selector(pinch))
        select = UITapGestureRecognizer.init(target: self, action: #selector(tap))
        move = UIPanGestureRecognizer.init(target: self, action: #selector(pan))
        press = UILongPressGestureRecognizer.init(target: self, action: #selector((popOver)))
        
        //adds the gesture recognizers to the button
        button.addGestureRecognizer(zoom)
        button.addGestureRecognizer(select)
        button.addGestureRecognizer(move)
        button.addGestureRecognizer(press)
        
        //disables gestures at the start
        zoom.isEnabled = false
        move.isEnabled = false
        press.isEnabled = false
    }
    
    /*
     Tapping function for booths
     */
    @objc func tap(gesture: UITapGestureRecognizer)
    {
        if let controller = UIApplication.shared.keyWindow?.rootViewController as? MapViewController
        {
            controller.scrollView.isScrollEnabled = false
            controller.disableZoom()
        }
        zoom.isEnabled = true
        move.isEnabled = true
        press.isEnabled = true
        if(col == "red")
        {
            col = "yellow"
            button.setBackgroundImage(UIImage.init(named: "YellowCircle"), for: UIControlState.normal)
        }
        else
        {
            col = "red"
            button.setBackgroundImage(UIImage.init(named: "RedCircle"), for: UIControlState.normal)
        }
    }
    
    /*
     Zooming function for booths
    */
    @objc func pinch(gesture: UIPinchGestureRecognizer)
    {
        if let viewer = gesture.view
        {
            if !(viewer.frame.maxX * gesture.scale > (button.superview?.bounds.width)! || viewer.frame.minX * gesture.scale < 0 || viewer.frame.maxY * gesture.scale > (button.superview?.bounds.height)! || viewer.frame.minY * gesture.scale < 0)
            {
                viewer.transform = viewer.transform.scaledBy(x: gesture.scale, y: gesture.scale)
                gesture.scale = 1
            }
        }
    }
    
    /*
     Moving function for booths
     */
    @objc func pan(gesture: UIPanGestureRecognizer)
    {
        let translation = gesture.translation(in: button.superview)
        if let viewer = gesture.view
        {
            if !(viewer.frame.maxX + translation.x > (button.superview?.bounds.width)! || viewer.frame.minX + translation.x < 0 || viewer.frame.maxY + translation.y > (button.superview?.bounds.height)! || viewer.frame.minY + translation.y < 0)
            {
                viewer.center = CGPoint.init(x: viewer.center.x + translation.x, y: viewer.center.y + translation.y)
                gesture.setTranslation(CGPoint.init(x: 0, y: 0), in: button.superview)
            }
        }
    }
    
    /*
     Initiates popover function in the view controller
    */
    @objc func popOver(gesture: UILongPressGestureRecognizer)
    {
        let rootVC = UIApplication.shared.keyWindow?.rootViewController as! MapViewController
        rootVC.popOver(self)
    }
}
