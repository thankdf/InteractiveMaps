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
    var address: String?
    var latitude: String?
    var longitude: String?
    
    
    //empty constructor
    
    override init()
    {
        
    }
    
    //construct with @name, @address, @latitude, and @longitude parameters
    
    init(event_name: String, address: String, latitude: String, longitude: String) {
        
        self.event_name = event_name
        self.address = address
        self.latitude = latitude
        self.longitude = longitude
        
    }
    
    
    //prints object's current state
    
    override var description: String {
        return "Name: \(event_name), Address: \(address), Latitude: \(latitude), Longitude: \(longitude)"
        
}

}
