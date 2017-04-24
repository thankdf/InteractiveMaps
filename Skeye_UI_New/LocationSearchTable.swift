//
//  LocationSearchTable.swift
//  Skeye_UI_New
//
//  Created by Sandeep Kaur on 3/20/17.
//  Copyright © 2017 Sandeep Kaur. All rights reserved.
//


import MapKit
import UIKit
class LocationSearchTable : UIViewController, UITableViewDataSource, UITableViewDelegate, HomeModelProtocal, UISearchBarDelegate, UIKit.UISearchResultsUpdating{

    //Properties
    
    var mapView: MKMapView? = nil
    var feedItems: NSArray = NSArray()
    var listTableView: UITableView! = nil
    var selectedLocation : LocationModel = LocationModel()
    
   // @IBOutlet weak var listTableView: UITableView!
    
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
    
/*    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
 
        print("doSearch is working")

 
    }
 
 */
    
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
      //  myCell.textLabel!.text = item.event_name
        myCell.textLabel!.text = item.event_name

      
    
        return myCell
    }
}


