//
//  LocationSearchTable.swift
//  Skeye
//
//  Created by Sandeep Kaur on 3/28/17.
//  Copyright © 2017 Team Skeye. All rights reserved.
//


import MapKit
import UIKit

class LocationSearchTable : UIViewController, UITableViewDataSource, UITableViewDelegate, HomeModelProtocal, UISearchBarDelegate, UIKit.UISearchResultsUpdating{

    //Properties
    
    var mapView: MKMapView? = nil
    var feedItems: NSArray = NSArray()
    var selectedLocation : LocationModel = LocationModel()
    
    @IBOutlet var listTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //set delegates and initialize homeModel
        
        self.listTableView.delegate = self
        self.listTableView.dataSource = self
        

        
    }
    
    
    func updateSearchResults(for searchController: UISearchController)
    
    {
        guard let _ = mapView,
        let searchBarText = searchController.searchBar.text else { return }
       
        print(searchBarText)

        let homeModel = HomeModel()
        homeModel.delegate = self
        homeModel.doSearch(searchWord: searchBarText)

        
    }
    

    
    func itemsDownloaded(items: NSArray) {
          print("tableView is working")
        feedItems = items
        self.listTableView.reloadData()
        print(feedItems)

        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of feed items
        return feedItems.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Retrieve cell
        let cellIdentifier: String = "cell"
        let myCell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier)!
        // Get the location to be shown
        let item: LocationModel = feedItems[indexPath.row] as! LocationModel
        // Get references to labels of cell
        myCell.textLabel!.text = item.event_name
  
        return myCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Set selected location to var
        selectedLocation = feedItems[indexPath.row] as! LocationModel
        // Manually call segue to detail view controller
        self.performSegue(withIdentifier: "eventPinSegue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "eventPinSegue"
        {
        // Get reference to the destination view controller
        let detailVC  = segue.destination as! SearchViewController
        // Set the property to the selected location so when the view for
        // detail view controller loads, it can access that property to get the feeditem obj
        detailVC.selectedLocation = selectedLocation
        }
    }
}


