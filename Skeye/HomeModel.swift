
//  HomeModel.swift
//  Skeye
//
//  Created by Sandeep Kaur on 4/16/17.
//  Copyright © 2017 Sandeep Kaur. All rights reserved.
//

import Foundation


protocol HomeModelProtocal: class {
    func itemsDownloaded(items: NSArray)
}


class HomeModel: NSObject, URLSessionDataDelegate {
    
    //properties
    
    weak var delegate: HomeModelProtocal!
    
    
    
    var data : NSMutableData = NSMutableData()
    
    let urlPath: String = "http://130.65.159.80/service.php"
    
    func doSearch(searchWord: String) {
        let url = URL(string: urlPath)
        var request = URLRequest(url: url!)
        request.httpMethod = "POST";
        
        let postString = "searchWord=\(searchWord)"
        
        
        request.httpBody = postString.data(using: String.Encoding.utf8)
        
        let task = URLSession.shared.dataTask(with: request) {
            
            (data: Data?, response: URLResponse?, error: Error?) in
            
            if error != nil {
                print("error=\(error)")
                return
            }
            
            
            self.data.append(data! as Data);
            
            print("Data downloaded")
            self.parseJSON()
            
        }
        task.resume()
        
        
    }
    
    func parseJSON() {
        
        var jsonResult = [[String:Any]]()
        
        do{
            jsonResult = try JSONSerialization.jsonObject(with: self.data as Data, options: JSONSerialization.ReadingOptions.allowFragments) as! [[String:Any]]
            
        } catch let error as NSError {
            print(error)
            
        }
        
        let locations: NSMutableArray = NSMutableArray()
        
        for json in jsonResult
        {
            //the following insures none of the JsonElement values are nil through optional binding
            if let event_name = json["event_name"] as? String,
                let username = json["username"] as? String,
                let street_address = json["street_address"] as? String,
                let city = json["city"] as? String,
                let state = json["state"] as? String,
                let zipcode = json["zipcode"] as? String,
                let event_id = Int((json["event_id"] as? String)!)
                
                
            {
                let location = LocationModel()
                
                location.event_name = event_name
                location.username = username
                location.street_address = street_address
                location.city = city
                location.state = state
                location.zipcode = zipcode
                location.event_id = event_id
                
                
                
                locations.add(location)
            }
            
            
        }
        
        DispatchQueue.main.async(execute: { () -> Void in
            self.delegate.itemsDownloaded(items: locations)
            
        })
    }
}
