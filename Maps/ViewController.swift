//
//  ViewController.swift
//  Maps
//
//  Created by Kevin Dang on 10/15/16.
//  Copyright © 2016 Team_Interactive_Maps. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var booths: [BoothProperties] = [BoothProperties]() //booths to be implemented
    var selectedBoothShape: UIImage? = nil //current shape user selected, will be removed in future versions
    @IBOutlet weak var boothView: BoothProperties!
    {
        didSet
        {
            boothView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(addBooth)))
        }
    }
    @IBOutlet weak var shapeView: UIScrollView!
    {
        didSet
        {
            shapeView.contentSize = CGSize.init(width: 500, height: shapeView.contentSize.height)
            shapeView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(setBoothShape)))
        }
    }
    
    @IBAction func setBoothShape(shape: UIButton) //user clicks on shape name and shape will automatically change to that shape
    {
        if let newImage = shape.imageView
        {
            selectedBoothShape = newImage.image
        }
    }
    
    @IBAction func addBooth(gesture: UITapGestureRecognizer) //adds booth
    {
        if let _ = selectedBoothShape
        {
            for booth in booths
            {
                booth.isUserInteractionEnabled = false
            }
            let frame = CGRect.init(origin: CGPoint.init(x: gesture.location(in: boothView).x + (selectedBoothShape?.size.width)!/2, y: gesture.location(in: boothView).y + (selectedBoothShape?.size)!.height/2), size: (selectedBoothShape?.size)!)
            let button = BoothProperties()
            button.frame = frame
            print("\(frame.minX), \(frame.minY), \(frame.maxX), \(frame.maxY)")
            button.setBackgroundImage(selectedBoothShape, for: UIControlState.normal)
            boothView.addGestureRecognizer(UILongPressGestureRecognizer(target: button, action: #selector(BoothProperties.selectBooth)))
            boothView.addGestureRecognizer(UIPinchGestureRecognizer(target: button, action: #selector(BoothProperties.changeDimensions)))
            boothView.addGestureRecognizer(UIPanGestureRecognizer(target: button, action: #selector(BoothProperties.translatePosition)))
            self.view.addSubview(button)
            booths.append(button)
        }
    }
}

