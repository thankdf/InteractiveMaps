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
    var shape: UIImage? = nil
    var ownerID: Int = 0
    var aframe: CGRect = CGRect.init()

    func setAttributes(newName: String, newID: Int, newInformation: String, newItems: Dictionary<String, Double>, newPhotos: [UIImage], newColor: UIColor, newShape: UIImage, newOwnerID: Int, newFrame: CGRect)
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
    
    func changeBoothShape(newShape: UIImage)
    {
        shape = newShape
    }
}
