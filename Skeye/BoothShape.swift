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
        switch(geometry)
        {
        case "circle":
            switch(col)
            {
            case("white"):
                button.setBackgroundImage(UIImage.init(named: "WhiteCircle"), for: UIControlState.normal)
            case("red"):
                button.setBackgroundImage(UIImage.init(named: "RedCircle"), for: UIControlState.normal)
            default: break
            }
        default: break
        }
        zoom = UIPinchGestureRecognizer.init(target: self, action: #selector(pinch))
        select = UITapGestureRecognizer.init(target: self, action: #selector(tap))
        move = UIPanGestureRecognizer.init(target: self, action: #selector(pan))
        press = UILongPressGestureRecognizer.init(target: self, action: #selector((popOver)))
        button.addGestureRecognizer(zoom)
        button.addGestureRecognizer(select)
        button.addGestureRecognizer(move)
        button.addGestureRecognizer(press)
    }
    
    @objc func tap(gesture: UITapGestureRecognizer)
    {
        for gesture in (self.button.superview?.gestureRecognizers)!
        {
            if !(gesture.isKind(of: UITapGestureRecognizer.self))
            {
                gesture.isEnabled = false
            }
        }
        
//        if(col == "red")
//        {
//            col = "white"
//            button.setBackgroundgeometry(UIgeometry.init(named: "WhiteCircle"), for: UIControlState.normal)
//        }
//        else
//        {
//            col = "red"
//            button.setBackgroundgeometry(UIgeometry.init(named: "RedCircle"), for: UIControlState.normal)
//        }
    }
    
    @objc func pinch(gesture: UIPinchGestureRecognizer)
    {
        if let viewer = gesture.view
        {
            if !((viewer.frame.maxX - button.bounds.width) * gesture.scale < 0 || viewer.frame.minX * gesture.scale > (button.superview?.bounds.width)! - button.bounds.width || (viewer.frame.maxY - button.bounds.height) * gesture.scale < 0 || viewer.frame.minY * gesture.scale > (button.superview?.bounds.height)! - button.bounds.height)
            {
                viewer.transform = viewer.transform.scaledBy(x: gesture.scale, y: gesture.scale)
                gesture.scale = 1
            }
        }
    }
    
    @objc func pan(gesture: UIPanGestureRecognizer)
    {
        let translation = gesture.translation(in: button.superview)
        if let viewer = gesture.view
        {
            button.superview?.backgroundColor = UIColor.green
            if !(viewer.frame.maxX + translation.x - button.bounds.width < 0 || viewer.frame.minX + translation.x > (button.superview?.bounds.width)! - button.bounds.width || viewer.frame.maxY + translation.y - button.bounds.height < 0 || viewer.frame.minY + translation.y > (button.superview?.bounds.height)! - button.bounds.height)
            {
                viewer.center = CGPoint.init(x: viewer.center.x + translation.x, y: viewer.center.y + translation.y)
                gesture.setTranslation(CGPoint.init(x: 0, y: 0), in: button.superview)
            }
        }
    }
    
    @objc func popOver(gesture: UILongPressGestureRecognizer)
    {
        let rootVC = UIApplication.shared.keyWindow?.rootViewController as! MapViewController
        rootVC.popOver(self)
    }
}
