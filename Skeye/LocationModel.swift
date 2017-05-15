//
//  LocationModal.swift
//  Skeye
//
//  Created by Sandeep Kaur on 4/16/17.
//  Copyright © 2017 Sandeep Kaur. All rights reserved.
//

import Foundation

class LocationModel: NSObject {
    
    //properties
    
    var event_name: String?
    var username: String?
    var event_id: intmax_t?
    var start_date: String?
    var end_date: String?
    var start_time: String?
    var end_time: String?
    
    var address_id: intmax_t?
    var street_address: String?
    var city: String?
    var state: String?
    var zipcode: String?
    
    var booth_id: intmax_t?
    var booth_info: String?
    
    
    
    
    override init()
    {
        
    }
    
    
    init(event_name: String, username: String, event_id: intmax_t, address_id: intmax_t, street_address: String, city: String, state: String, zipcode: String, booth_id: intmax_t, booth_info: String) {
        
        self.event_name = event_name
        self.username = username
        self.event_id = event_id
        self.address_id = address_id
        self.street_address = street_address
        self.city = city
        self.state = state
        self.zipcode = zipcode
        self.booth_id = booth_id
        self.booth_info = booth_info
        
        
    }
    
    
    //prints object's current state
    
    override var description: String {
        return "event_name: \(event_name!), username: \(username!)"
        
    }
    
}
