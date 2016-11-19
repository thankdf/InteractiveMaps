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
    var name: String = ""
    var ID: Int = 0
    var information: String = ""
    var items: Dictionary<String, Double> = Dictionary<String, Double>()
    var photos: [UIImage] = [UIImage]()
    var color: UIColor = UIColor.white
    var shape: String = ""
    var ownerID: Int = 0
    var aframe: CGRect = CGRect.init()

    func setAttributes(newName: String, newID: Int, newInformation: String, newItems: Dictionary<String, Double>, newPhotos: [UIImage], newColor: UIColor, newShape: String, newOwnerID: Int, newFrame: CGRect)
    {
        name = newName
        ID = newID
        information = newInformation
        items = newItems
        photos = newPhotos
        color = newColor
        shape = newShape
        ownerID = newOwnerID
        aframe = newFrame
    }
    
    @IBInspectable var borderWidth: CGFloat = 0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }
    @IBInspectable var border: UIColor? {
        didSet {
            layer.borderColor = border?.cgColor
        }
    }
    @IBInspectable var background: UIColor? {
        didSet {
            layer.backgroundColor = background?.cgColor
        }
    }
    
    func changeBoothName(newName: String)
    {
        name = newName
    }
    
    func changeBoothInformation(newInformation: String)
    {
        information = newInformation
    }
    
    func changeBoothShape(newShape: String)
    {
        shape = newShape
    }
    
    override func draw(_ rect: CGRect)
    {
        switch(shape)
        {
        case("Circle"):
            let path: UIBezierPath = UIBezierPath.init(arcCenter: CGPoint.init(x: aframe.midX, y: aframe.midY), radius: min((CGFloat)(aframe.width/2), (CGFloat)(aframe.height/2)), startAngle: 0, endAngle: 360, clockwise: true)
            path.stroke()
        case("Square"):
            break
        case("Triangle"):
            break
        default: break
        }
    }
    
}
