//
//  Shapes.swift
//  Interactive_Maps
//
//  Created by Kevin Dang on 10/15/16.
//  Copyright © 2016 Team_Interactive_Maps. All rights reserved.
//

import UIKit

class BoothProperties: UIButton
{
//    var name: String
//    let ID: Int
//    var information: String
//    var items: Dictionary<String, Double> = Dictionary<String, Double>()
//    var photos: [UIImage]
//    var color: UIColor = UIColor.white
//    var shape: UIImage
//    let ownerID: Int
//
//    
//    func changeBoothName(newName: String)
//    {
//        name = newName
//    }
//    
//    func changeBoothInformation(newInformation: String)
//    {
//        information = newInformation
//    }
//    
//    func changeBoothShape(newShape: UIImage)
//    {
//        shape = newShape
//    }
//    
    /*
    Zooming Function
    */
    func changeDimensions(gesture: UIPinchGestureRecognizer)
    {
        if gesture.state == .changed
        {
            print("\(self.frame.minX), \(self.frame.minY), \(self.frame.maxX), \(self.frame.maxY)")
            print(superview?.subviews.first?.bounds.minX)
            //if the booth's area is greater than 5x5 pixels to prevent small-scale zooming and the bounds are within the container
            if (((superview?.bounds.maxX)! > self.frame.maxX * gesture.scale && (superview?.bounds.minX)! < self.frame.minX * gesture.scale
                && (superview?.bounds.maxY)! > self.frame.maxY * gesture.scale && (superview?.bounds.minY)! < self.frame.minY * gesture.scale) && self.frame.width*self.frame.height > 25)
            {
                //formula for zooming in and out with center as reference point
                self.frame = CGRect.init(origin: CGPoint.init(x: self.frame.origin.x + (1-gesture.scale)*self.bounds.width/2, y: self.frame.origin.y + (1-gesture.scale)*self.bounds.height/2), size: CGSize.init(width: self.frame.width * gesture.scale, height: self.frame.height * gesture.scale))
                //reset the scale of the gesture
                gesture.scale = 1
            }
        }
    }
    
    @IBAction func selectBooth(gesture: UILongPressGestureRecognizer) //selects the booth
    {
            if self.frame.contains(gesture.location(in: superview))
            {
                self.isUserInteractionEnabled = true
            }
            else
            {
                self.isUserInteractionEnabled = false
            }
            
    }
    
    @IBAction func translatePosition(gesture: UIPanGestureRecognizer)
    {
        if self.frame.contains(gesture.location(in: superview))
        {
            self.frame.origin = CGPoint.init(x: self.frame.origin.x + gesture.translation(in: superview).x, y: self.frame.origin.y + gesture.translation(in: superview).y)
        }
    }
}
