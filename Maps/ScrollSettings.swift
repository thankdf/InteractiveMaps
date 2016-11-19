//
//  ScrollSettings.swift
//  Maps
//
//  Created by Kevin Dang on 10/27/16.
//  Copyright © 2016 Team_Interactive_Maps. All rights reserved.
//

import UIKit

class ScrollSettings: UIScrollView
{
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
}
