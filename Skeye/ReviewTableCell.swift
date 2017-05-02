//
//  ReviewTableViewCell.swift
//  Skeye
//
//  Created by yoho chen on 4/21/17.
//  Copyright © 2017 Team_Parking. All rights reserved.
//

import UIKit

class ReviewTableViewCell: UITableViewCell {
    
    var reviewVC : ReviewViewController?
    
    @IBOutlet weak var userImage: UIImageView!
    
    @IBOutlet weak var userName: UILabel!
    
    @IBOutlet weak var userReview: UILabel!
    
    @IBOutlet weak var reviewTimeStapm: UILabel!
    
    @IBOutlet weak var reviewImage1: UIImageView!
    
    @IBOutlet weak var reviewImage2: UIImageView!
    
    @IBOutlet weak var reviewImage3: UIImageView!
    
    
    func configureCellWith(row: Int){
        userImage.image = #imageLiteral(resourceName: "userIcon")
        
        reviewImage1.addGestureRecognizer(setTapGestureRecognizer())
        reviewImage2.addGestureRecognizer(setTapGestureRecognizer())
        reviewImage3.addGestureRecognizer(setTapGestureRecognizer())
        
        
        
        //        if(row % 2 == 0)
        //        {
        //            reviewTimeStapm?.removeFromSuperview()
        //
        //
        //            NSLayoutConstraint(item: userImage, attribute: NSLayoutAttribute.leading, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.leadingMargin, multiplier: 1.0, constant: 50.0).isActive = true
        //
        //            //NSLayoutConstraint(item: userReview, attribute: NSLayoutAttribute.bottom, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.bottomMargin, multiplier: 1.0, constant: 50.0).isActive = true
        //
        //        }
    }
    
    func setTapGestureRecognizer() -> UITapGestureRecognizer {
        
        let tapRecognizer = UITapGestureRecognizer (target: self, action: #selector(animate(sender:)))
        
        return tapRecognizer
    }
    
    
    
    func animate( sender: UIGestureRecognizer)
    {
        let preparedFrame = reviewImage1.convert((sender.view?.frame)!, to: self.superview)
        reviewVC?.animateImageview(reviewImage: sender.view as! UIImageView, startingFrame: preparedFrame)
        
    }
    
    
}
