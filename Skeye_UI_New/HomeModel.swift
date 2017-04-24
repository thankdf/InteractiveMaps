
//  HomeModel.swift
//  Skeye_UI_New
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
        
       // let url: URL = URL(string: urlPath)!
      //  var session: URLSession!
     //   let configuration = URLSessionConfiguration.default
        
       // let request = NSMutableURLRequest(url:url as URL);
        //var request = URLRequest(url: url!)
         var request = URLRequest(url: url!)
        request.httpMethod = "POST";
        //request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let postString = "searchWord=\(searchWord)"
        
       // let postString = "searchWord=\(searchWord)".addingPercentEncoding(withAllowedCharacters:NSCharacterSet.urlQueryAllowed);
        print(postString);
        
        request.httpBody = postString.data(using: String.Encoding.utf8)
        //request.setValue("\(request.httpBody?.count)", forHTTPHeaderField:"Content-Length")

      //  session = URLSession(configuration: configuration, delegate: self, delegateQueue: nil)
        
        print(request)

        let task = URLSession.shared.dataTask(with: request) {
            
            (data: Data?, response: URLResponse?, error: Error?) in
            
            if error != nil {
                print("error=\(error)")
                return
            }
            
            let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
            print("responseString = \(responseString)")
            self.data.append(data! as Data);

            
  
//            self.data.append(data! as Data);
//
//            print("Data downloaded")
//            self.parseJSON()
//            
        }
        task.resume()
    
    
    }
    
    func parseJSON() {
        
        var jsonResult = [String:Any]()
        
        do{
            jsonResult = try JSONSerialization.jsonObject(with: self.data as Data, options: JSONSerialization.ReadingOptions.allowFragments) as! [String:Any]
            
        } catch let error as NSError {
             print(error)
            
        }
        
       // var jsonElement = [String:Any]()
        var locations = [LocationModel]()
        
        for _ in (0...(jsonResult.count)).reversed()
        {
            print(jsonResult)

            //jsonElement = jsonResult[i]
            let location = LocationModel()
            
            //the following insures none of the JsonElement values are nil through optional binding
            if let event_name = jsonResult["event_name"] as? String,
               let username = jsonResult["username"] as? String

   /*             let address = jsonElement["Address"] as? String,
                let latitude = jsonElement["Latitude"] as? String,
                let longitude = jsonElement["Longitude"] as? String
 */
            {
                
                location.event_name = event_name
                location.username = username

   /*             location.address = address
                location.latitude = latitude
                location.longitude = longitude
                
 */
            }
            
            locations.append(location)
            
        }
        
            DispatchQueue.main.async(execute: { () -> Void in
            self.delegate.itemsDownloaded(items: locations as NSArray)
            
        })
    }
}
