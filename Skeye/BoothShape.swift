//
//  BoothShape.swift
//  Skeye
//
//  Created by Kevin Dang on 2/13/17.
//  Copyright © 2017 Team_Skeye. All rights reserved.
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
    var date: String
    var boothPhotos: [UIImage]
    var id: Int
    var user: String
    
    //Gesture recognizers
    var zoom: UIPinchGestureRecognizer
    var select: UITapGestureRecognizer
    var move: UIPanGestureRecognizer
    var press: UILongPressGestureRecognizer
    
    init(_ point: CGPoint, _ size: CGSize, _ shape: String, _ color: String, _ iden: Int, _ type: String)
    {
        origin = point
        rectangle = size
        geometry = shape
        col = color
        button = UIButton()
        button.setTitle("Test!", for: UIControlState.normal)
        zoom = UIPinchGestureRecognizer.init();
        select = UITapGestureRecognizer.init();
        move = UIPanGestureRecognizer.init();
        press = UILongPressGestureRecognizer.init()
        name = "Default name"
        info = "Default info"
        date = ""
        boothPhotos = []
        id = iden
        user = type
    }
    
    init(_ point: CGPoint, _ size: CGSize, _ shape: String, _ color: String, _ click: UIButton, _ zoomGesture: UIPinchGestureRecognizer, _ selectGesture: UITapGestureRecognizer, _ moveGesture: UIPanGestureRecognizer, _ pressGesture: UILongPressGestureRecognizer, _ boothName: String, _ information: String, _ time: String, _ booths: [UIImage], _ iden: Int, _ type: String)
    {
        origin = point
        rectangle = size
        geometry = shape
        col = color
        button = click
        button.setTitle("Test!", for: UIControlState.normal)
        zoom = zoomGesture
        select = selectGesture
        move = moveGesture
        press = UILongPressGestureRecognizer.init()
        name = boothName
        info = information
        date = time
        boothPhotos = booths
        id = iden
        user = type
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
                case("orange"):
                    button.setBackgroundImage(UIImage.init(named: "OrangeCircle"), for: UIControlState.normal)
                case("yellow"):
                    button.setBackgroundImage(UIImage.init(named: "YellowCircle"), for: UIControlState.normal)
                case("green"):
                    button.setBackgroundImage(UIImage.init(named: "GreenCircle"), for: UIControlState.normal)
                case("blue"):
                    button.setBackgroundImage(UIImage.init(named: "BlueCircle"), for: UIControlState.normal)
                case("purple"):
                    button.setBackgroundImage(UIImage.init(named: "PurpleCircle"), for: UIControlState.normal)
                default: break
                }
            case "square":
                switch(col)
                {
                case("white"):
                    button.setBackgroundImage(UIImage.init(named: "WhiteSquare"), for: UIControlState.normal)
                case("red"):
                    button.setBackgroundImage(UIImage.init(named: "RedSquare"), for: UIControlState.normal)
                case("orange"):
                    button.setBackgroundImage(UIImage.init(named: "OrangeSquare"), for: UIControlState.normal)
                case("yellow"):
                    button.setBackgroundImage(UIImage.init(named: "YellowSquare"), for: UIControlState.normal)
                case("green"):
                    button.setBackgroundImage(UIImage.init(named: "GreenSquare"), for: UIControlState.normal)
                case("blue"):
                    button.setBackgroundImage(UIImage.init(named: "BlueSquare"), for: UIControlState.normal)
                case("purple"):
                    button.setBackgroundImage(UIImage.init(named: "PurpleSquare"), for: UIControlState.normal)
                default: break
            }
            default: break
        }
        
        //initializes gesture recognizers
        zoom = UIPinchGestureRecognizer.init(target: self, action: #selector(pinch))
        select = UITapGestureRecognizer.init(target: self, action: #selector(tap))
        move = UIPanGestureRecognizer.init(target: self, action: #selector(pan))
        press = UILongPressGestureRecognizer.init(target: self, action: #selector((popOverBoothDetails)))
        
        //adds the gesture recognizers to the button
        button.addGestureRecognizer(zoom)
        button.addGestureRecognizer(select)
        button.addGestureRecognizer(move)
        button.addGestureRecognizer(press)
        
        //disables gestures at the start
        zoom.isEnabled = false
        move.isEnabled = false
    }
    
    /*
     Tapping function for booths
     */
    @objc func tap(gesture: UITapGestureRecognizer)
    {
        if let controller = UIApplication.shared.keyWindow?.rootViewController as? MapViewController
        {
            if(zoom.isEnabled && move.isEnabled && press.isEnabled)
            {
                if(controller.changeShapeButtonPressed)
                {
                    switch(geometry)
                    {
                    case("circle"):
                        switch(col)
                        {
                        case("white"):
                            geometry = "square"
                            button.setBackgroundImage(UIImage.init(named: "WhiteSquare"), for: UIControlState.normal)
                        case("red"):
                            geometry = "square"
                            button.setBackgroundImage(UIImage.init(named: "RedSquare"), for: UIControlState.normal)
                        case("orange"):
                            geometry = "square"
                            button.setBackgroundImage(UIImage.init(named: "OrangeSquare"), for: UIControlState.normal)
                        case("yellow"):
                            geometry = "square"
                            button.setBackgroundImage(UIImage.init(named: "YellowSquare"), for: UIControlState.normal)
                        case("green"):
                            geometry = "square"
                            button.setBackgroundImage(UIImage.init(named: "GreenSquare"), for: UIControlState.normal)
                        case("blue"):
                            geometry = "square"
                            button.setBackgroundImage(UIImage.init(named: "BlueSquare"), for: UIControlState.normal)
                        case("purple"):
                            geometry = "square"
                            button.setBackgroundImage(UIImage.init(named: "PurpleSquare"), for: UIControlState.normal)
                        default: break
                        }
                    case "square":
                        switch(col)
                        {
                        case("white"):
                            geometry = "circle"
                            button.setBackgroundImage(UIImage.init(named: "WhiteCircle"), for: UIControlState.normal)
                        case("red"):
                            geometry = "circle"
                            button.setBackgroundImage(UIImage.init(named: "RedCircle"), for: UIControlState.normal)
                        case("orange"):
                            geometry = "circle"
                            button.setBackgroundImage(UIImage.init(named: "OrangeCircle"), for: UIControlState.normal)
                        case("yellow"):
                            geometry = "circle"
                            button.setBackgroundImage(UIImage.init(named: "YellowCircle"), for: UIControlState.normal)
                        case("green"):
                            geometry = "circle"
                            button.setBackgroundImage(UIImage.init(named: "GreenCircle"), for: UIControlState.normal)
                        case("blue"):
                            geometry = "circle"
                            button.setBackgroundImage(UIImage.init(named: "BlueCircle"), for: UIControlState.normal)
                        case("purple"):
                            geometry = "circle"
                            button.setBackgroundImage(UIImage.init(named: "PurpleCircle"), for: UIControlState.normal)
                        default: break
                        }
                        
                    default: break
                    }
                    controller.changeShapeButtonPressed = false
                }
                else if(controller.changeColorButtonPressed)
                {
                    switch(geometry)
                    {
                    case("circle"):
                        switch(col)
                        {
                        case("white"):
                            col = "red"
                            button.setBackgroundImage(UIImage.init(named: "RedCircle"), for: UIControlState.normal)
                        case("red"):
                            col = "orange"
                            button.setBackgroundImage(UIImage.init(named: "OrangeCircle"), for: UIControlState.normal)
                        case("orange"):
                            col = "yellow"
                            button.setBackgroundImage(UIImage.init(named: "YellowCircle"), for: UIControlState.normal)
                        case("yellow"):
                            col = "green"
                            button.setBackgroundImage(UIImage.init(named: "GreenCircle"), for: UIControlState.normal)
                        case("green"):
                            col = "blue"
                            button.setBackgroundImage(UIImage.init(named: "BlueCircle"), for: UIControlState.normal)
                        case("blue"):
                            col = "purple"
                            button.setBackgroundImage(UIImage.init(named: "PurpleCircle"), for: UIControlState.normal)
                        case("purple"):
                            col = "white"
                            button.setBackgroundImage(UIImage.init(named: "WhiteCircle"), for: UIControlState.normal)
                        default: break
                        }
                    case "square":
                        switch(col)
                        {
                        case("white"):
                            col = "red"
                            button.setBackgroundImage(UIImage.init(named: "RedSquare"), for: UIControlState.normal)
                        case("red"):
                            col = "orange"
                            button.setBackgroundImage(UIImage.init(named: "OrangeSquare"), for: UIControlState.normal)
                        case("orange"):
                            col = "yellow"
                            button.setBackgroundImage(UIImage.init(named: "YellowSquare"), for: UIControlState.normal)
                        case("yellow"):
                            col = "green"
                            button.setBackgroundImage(UIImage.init(named: "GreenSquare"), for: UIControlState.normal)
                        case("green"):
                            col = "blue"
                            button.setBackgroundImage(UIImage.init(named: "BlueSquare"), for: UIControlState.normal)
                        case("blue"):
                            col = "purple"
                            button.setBackgroundImage(UIImage.init(named: "PurpleSquare"), for: UIControlState.normal)
                        case("purple"):
                            col = "white"
                            button.setBackgroundImage(UIImage.init(named: "WhiteSquare"), for: UIControlState.normal)
                        default: break
                        }
                        
                    default: break
                    }
                    controller.changeColorButtonPressed = false
                }
            }
            else
            {
                controller.scrollView.isScrollEnabled = false
                controller.disableZoom()
                for booth in controller.booths
                {
                    booth.zoom.isEnabled = false
                    booth.move.isEnabled = false
                }
                zoom.isEnabled = true
                move.isEnabled = true
                press.isEnabled = true
            }
        }
    }
    
    /*
     Zooming function for booths
    */
    @objc func pinch(gesture: UIPinchGestureRecognizer)
    {
        if let viewer = gesture.view
        {
            if let controller = UIApplication.shared.keyWindow?.rootViewController as? MapViewController
            {
                if(gesture.state == UIGestureRecognizerState.began)
                {
                    controller.lastBooth = BoothShape.init(origin, rectangle, geometry, col, button, zoom, select, move, press, name, info, date, boothPhotos, id, user) //last saved state
                }
                if !(viewer.frame.maxX * gesture.scale > (button.superview?.bounds.width)! || viewer.frame.minX * gesture.scale < 0 || viewer.frame.maxY * gesture.scale > (button.superview?.bounds.height)! || viewer.frame.minY * gesture.scale < 0) //if the zoom stays within the frame
                {
                    viewer.transform = viewer.transform.scaledBy(x: gesture.scale, y: gesture.scale)
                    rectangle = CGSize.init(width: viewer.frame.width * gesture.scale, height: viewer.frame.height * gesture.scale)
                    gesture.scale = 1
                }
                if(gesture.state == UIGestureRecognizerState.ended)
                {
                    controller.undoButton.isEnabled = true
                    controller.currentBooth = BoothShape.init(origin, CGSize.init(width: viewer.frame.width * gesture.scale, height: viewer.frame.height * gesture.scale), geometry, col, button, zoom, select, move, press, name, info, date, boothPhotos, id, user) //update rectangle size
                }
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
            if let controller = UIApplication.shared.keyWindow?.rootViewController as? MapViewController
            {
                if(gesture.state == UIGestureRecognizerState.began)
                {
                    controller.lastBooth = BoothShape.init(origin, rectangle, geometry, col, button, zoom, select, move, press, name, info, date, boothPhotos, id, user) //last saved state
                }
                if !(viewer.frame.maxX + translation.x > (button.superview?.bounds.width)! || viewer.frame.minX + translation.x < 0 || viewer.frame.maxY + translation.y > (button.superview?.bounds.height)! || viewer.frame.minY + translation.y < 0) //if the translation stays within the frame
                {
                    origin = CGPoint.init(x: viewer.center.x + translation.x, y: viewer.center.y + translation.y)
                    viewer.center = origin
                    gesture.setTranslation(CGPoint.init(x: 0, y: 0), in: button.superview)
                }
                if(gesture.state == UIGestureRecognizerState.ended)
                {
                    controller.undoButton.isEnabled = true
                    controller.currentBooth = BoothShape.init(origin, rectangle, geometry, col, button, zoom, select, move, press, name, info, date, boothPhotos, id, user) //update position
                }
            }
        }
    }
    
    /*
     Initiates popover function in the view controller
    */
    @objc func popOverBoothDetails(gesture: UILongPressGestureRecognizer)
    {
        let rootVC = UIApplication.shared.keyWindow?.rootViewController as! LoginViewController
        rootVC.popOver(self)
    }
    
    /*
     Initiates popover function in the view controller
     */
    @objc func popOverEventCoordinator(gesture: UILongPressGestureRecognizer)
    {
        let rootVC = UIApplication.shared.keyWindow?.rootViewController as! MapViewController
        //rootVC.popOver(self)
    }
    
    /*
     Comparing whether two booths are identical
    */
    func equals(_ shape: BoothShape) -> Bool
    {
        if(button == shape.button && origin == shape.origin && col == shape.col && geometry == shape.geometry && name == shape.name && info == shape.info && boothPhotos == shape.boothPhotos && id == shape.id && user == shape.user)
        {
            return true
        }
        return false
    }
}
