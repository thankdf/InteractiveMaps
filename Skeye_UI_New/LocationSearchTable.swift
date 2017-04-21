//
//  LocationSearchTable.swift
//  Skeye_UI_New
//
//  Created by Sandeep Kaur on 3/20/17.
//  Copyright © 2017 Sandeep Kaur. All rights reserved.
//


import MapKit
import UIKit
class LocationSearchTable : UITableViewController, HomeModelProtocal, UISearchBarDelegate, UIKit.UISearchResultsUpdating{

    //Properties
    
    var mapView: MKMapView? = nil
    var feedItems: NSArray = NSArray()
    var selectedLocation : LocationModel = LocationModel()
    @IBOutlet weak var listTableView: UITableView!
    
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
        print("doSearch is working")

        let homeModel = HomeModel()
        homeModel.delegate = self
        homeModel.doSearch(searchWord: searchBarText)

        
    }
    
/*    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
 
        print("doSearch is working")

 
    }
 
 */
    
    func itemsDownloaded(items: NSArray) {
        
        feedItems = items
        self.listTableView.reloadData()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of feed items
        return feedItems.count
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // Retrieve cell
        let cellIdentifier: String = "cell"
        let myCell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier)!
        // Get the location to be shown
        let item: LocationModel = feedItems[indexPath.row] as! LocationModel
        // Get references to labels of cell
        myCell.textLabel!.text = item.event_name
        
        return myCell
    }
}


