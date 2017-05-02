//
//  Review.swift
//  Skeye
//
//  Created by yoho chen on 4/26/17.
//  Copyright © 2017 Team_Parking. All rights reserved.
//

import UIKit
class Review
{
    var reviewID: Int?
    var comment: String
    var photos: [UIImage?]
    var boothID: Int
    var date: String
    var username : String
    
    init(reviewID: Int, comment: String, photos:[UIImage?], boothID: Int, date: String, username: String)
    {
        self.reviewID = reviewID
        self.comment = comment
        self.photos = photos
        self.boothID = boothID
        self.date = date
        self.username = username
    }
    
    init(comment: String, photos:[UIImage?], boothID: Int, date: String, username: String)
    {
        self.reviewID = nil
        self.comment = comment
        self.photos = photos
        self.boothID = boothID
        self.date = date
        self.username = username
    }
}
