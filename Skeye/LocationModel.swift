//
//  LocationModal.swift
//  Skeye_UI_New
//
//  Created by Sandeep Kaur on 4/16/17.
//  Copyright © 2017 Sandeep Kaur. All rights reserved.
//

import Foundation

class LocationModel: NSObject {
    
    //properties
    
    var event_name: String?
    var username: String?
   /* var latitude: String?
    var longitude: String?
   */
    
    
    override init()
    {
        
    }
    
    //construct with @name, @address, @latitude, and @longitude parameters
    
    init(event_name: String, username: String) {
        
        self.event_name = event_name
        self.username = username
        
    }
    
    
    //prints object's current state
    
    override var description: String {
        return "event_name: \(event_name), username: \(username)"
        
}

}
