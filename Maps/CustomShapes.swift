//
//  CustomShapes.swift
//  Maps
//
//  Created by Sandeep Kaur on 11/18/16.
//  Copyright © 2016 Team_Interactive_Maps. All rights reserved.
//

import UIKit

class CustomShapes: UIView {
    
    var lines: [Line] = []
    var lastPoint: CGPoint!
    var newPoint: CGPoint!
    
     required init(coder aDecoder: NSCoder){
        super.init(coder: aDecoder)!
    }
    
        @IBInspectable var cornerRadius: CGFloat = 0 {
            didSet {
                layer.cornerRadius = cornerRadius
                layer.masksToBounds = cornerRadius > 0
            }
        }
        @IBInspectable var borderWidth: CGFloat = 0 {
            didSet {
                layer.borderWidth = borderWidth
            }
        }
        @IBInspectable var borderColor: UIColor? {
            didSet {
                layer.borderColor = borderColor?.cgColor
            }
        }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch: AnyObject! in touches {
            lastPoint = touch.location(in: self)
    }
    }
      override  func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?){
            for touch: AnyObject! in touches {
                newPoint = touch.location(in: self)
            }
            lines.append(Line(start: lastPoint, end: newPoint))
            lastPoint = newPoint
        
        self.setNeedsDisplay()
        }
        
    override func draw(_ rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        context!.beginPath()
        for line in lines {
         
            context?.move(to: line.start)
            context?.addLine(to: line.end)
        }
       // context?.setLineCap(kCG)
        context?.setStrokeColor(red: 0, green: 0, blue: 0, alpha: 1)
        context?.setLineWidth(5)
        context?.strokePath()
    }
}
