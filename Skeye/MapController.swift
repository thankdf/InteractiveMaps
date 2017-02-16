//
//  ViewController.swift
//  Skeye
//
//  Created by Kevin Dang on 2/6/17.
//  Copyright © 2017 Team_Parking. All rights reserved.
//

import UIKit

class ViewController: UIViewController
{
    /* Map Boundaries */
    var frameMinimum: CGFloat = 250 //allowed frame boundaries
    var zoomMinimum: CGFloat = 400 //minimum zoom screen size
    
    /* Booleans */
    var shapeSelected = false //if user selected a shape before tapping on the screen
    
    /* Objects obtained from the database */
    var buttons: [BoothShape] = [BoothShape]() //list of booths
    var image: UIImage? = UIImage.init(named: "MapTemplate") //map image

    /* Gesture recognizers */
    var zoom: UIPinchGestureRecognizer = UIPinchGestureRecognizer.init()
    var select: UITapGestureRecognizer = UITapGestureRecognizer.init()
    var move: UIPanGestureRecognizer = UIPanGestureRecognizer.init()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
    }
    
    @IBOutlet weak var test: UIButton!
    {
        didSet
        {
            test.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(testButton)))
        }
    }
    
    @IBOutlet weak var mapImage: UIImageView!
    {
        didSet
        {
            mapImage.image = image
            mapImage.alpha = 0.25
            mapImage.sizeToFit()
            
            zoom = UIPinchGestureRecognizer(target: self, action: #selector(pinch))
            mapImage.addGestureRecognizer(zoom)
            select = UITapGestureRecognizer(target: self, action: #selector(tap))
            mapImage.addGestureRecognizer(select)
            move = UIPanGestureRecognizer(target: self, action: #selector(pan))
            mapImage.addGestureRecognizer(move)
        }
    }
    
    /*
     Controls zoom for the map and booths within a specified range
    */
    func pinch(gesture: UIPinchGestureRecognizer)
    {
        if let viewer = gesture.view
        {
            if !(viewer.frame.height < zoomMinimum && viewer.frame.width < zoomMinimum && gesture.scale < 1)
            {
                viewer.transform = viewer.transform.scaledBy(x: gesture.scale, y: gesture.scale)
                gesture.scale = 1
            }
        }
    }
    
    /*
     Controls movement for the map and booths within a specified range
     */
    func pan(gesture: UIPanGestureRecognizer)
    {
        let translation = gesture.translation(in: self.view)
        if let viewer = gesture.view
        {
            if !(viewer.frame.maxX + translation.x < frameMinimum || viewer.frame.minX + translation.x > self.view.frame.width - frameMinimum || viewer.frame.maxY + translation.y < frameMinimum || viewer.frame.minY + translation.y > self.view.frame.height - frameMinimum)
            {
                viewer.center = CGPoint.init(x: viewer.center.x + translation.x, y: viewer.center.y + translation.y)
                gesture.setTranslation(CGPoint.init(x: 0, y: 0), in: self.view)
            }
        }
    }
    
    /*
     Toggles on and off interaction with the map
    */
    func tap(gesture: UITapGestureRecognizer)
    {
        if(shapeSelected == true)
        {
            shapeSelected = false
            createBooth(gesture.location(in: self.mapImage), "circle")
        }
        else
        {
        }
    }
    
    func testButton(gesture: UITapGestureRecognizer)
    {
        shapeSelected = true
    }
    
    /*
    Creates a booth
    */
    func createBooth(_ point: CGPoint, _ shape: String)
    {
        let newButton: BoothShape = BoothShape.init(point, CGSize.init(width: 50, height: 50), shape, "white")
        newButton.draw(mapImage.bounds)
        mapImage.addSubview(newButton.button)
        buttons.append(newButton)
    }
}

