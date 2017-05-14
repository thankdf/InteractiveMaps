//
//  EventCoordinatorController.swift
//  Skeye
//
//  Created by Sandeep Kaur on 5/9/17.
//  Copyright © 2017 Skeye. All rights reserved.
//


import MapKit
import UIKit

class EventCoordinatorController : UIViewController, UITableViewDataSource, UITableViewDelegate, HomeModelProtocal{
    
    //Properties
    
    weak var delegate: HomeModelProtocal!
    var EventsList: NSArray = NSArray()
    var selectedLocation : LocationModel = LocationModel()
    
    
    @IBOutlet weak var eventsListTable: UITableView!
    
    var data : NSMutableData = NSMutableData()
    
    let urlPath: String = "http://130.65.159.80/EventList.php"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //set delegates and initialize homeModel
        
        self.eventsListTable.delegate = self
        self.eventsListTable.dataSource = self
        
        retrieveEventsList()
        
    }
    
    func itemsDownloaded(items: NSArray) {
        EventsList = items
        self.eventsListTable.reloadData()
        
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return EventsList.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier: String = "eventCell"
        let myCell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier)!
        // Get the location to be shown
        let item: LocationModel = EventsList[indexPath.row] as! LocationModel
        // Get references to labels of cell
        myCell.textLabel!.text = item.event_name
        
        return myCell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Set selected location to var
        selectedLocation = EventsList[indexPath.row] as! LocationModel
        // Manually call segue to detail view controller
        // self.performSegue(withIdentifier: "eventPinSegue", sender: self)
        self.performSegue(withIdentifier: "EventListToCoordinatorView", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // if segue.identifier == "eventPinSegue"
        if segue.identifier == "EventListToCoordinatorView"
            
        {
            // Get reference to the destination view controller
            let detailVC  = segue.destination as! MapViewController
            // Set the property to the selected location so when the view for
            // detail view controller loads, it can access that property to get the feeditem obj
            detailVC.selectedLocation = selectedLocation
        }
    }
    
    
    func retrieveEventsList()
    {
        
        let username = UserDefaults.standard.string(forKey: "username")
        
        let url = URL(string: urlPath)
        var request = URLRequest(url: url!)
        request.httpMethod = "POST";
        
        let postString = "username=\(username!)"
        
        print(postString)
        request.httpBody = postString.data(using: String.Encoding.utf8)
        
        
        let task = URLSession.shared.dataTask(with: request) {
            
            (data: Data?, response: URLResponse?, error: Error?) in
            
            if error != nil {
                print("error=\(error)")
                return
            }
            
            print("response = \(response)")
            
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
                let event_id = json["event_id"] as? String
                
            {
                let location = LocationModel()
                location.event_name = event_name
                location.username = username
                location.event_id = Int(event_id)
                
                locations.add(location)
            }
            
            
            
        }
        
        DispatchQueue.main.async(execute: { () -> Void in
            self.itemsDownloaded(items: locations)
            
        })
    }
    
    
    
}
