//
//  TabBarController.swift
//  Skeye_UI_New
//
//  Created by Sandeep Kaur on 5/1/17.
//  Copyright © 2017 Sandeep Kaur. All rights reserved.
//

import UIKit
import Foundation

class TabBarController : UITabBarController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    
}
    
    override func viewDidAppear(_ animated: Bool) {
        
        let user_type = "attendee"
        
        if(user_type == "event coordinator")
        {
        viewControllers?.remove(at:1)
        }
        
        else if(user_type == "booth owner")
        {
            viewControllers?.remove(at:2)

        }
        else if(user_type == "attendee")
        {
            viewControllers?.remove(at:1)
            viewControllers?.remove(at:1)

        }
        //testing commit
        
    }
    
  

}
