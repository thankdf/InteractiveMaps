//
//  ViewController.swift
//  Skeye_UI_New
//
//  Created by Sandeep Kaur on 3/19/17.
//  Copyright © 2017 Sandeep Kaur. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation


class SearchViewController : UIViewController, HomeModelProtocal {
    
    var resultSearchController:UISearchController? = nil
    var myAnnotationWithCallout:MKPointAnnotation? = nil
    var feedItems: NSArray = NSArray()
    var Address: String = ""

    
    let locationManager = CLLocationManager()
    var selectedLocation : LocationModel?
    
    @IBOutlet weak var mapView: MKMapView!
    
    @IBAction func BackButtonPressed(_ sender: UIButton) {
        let rootVC = UIApplication.shared.keyWindow?.rootViewController
        let searchController = rootVC!.storyboard!.instantiateViewController(withIdentifier: "TabBarController")
        
        self.present(searchController, animated: true, completion: nil)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        let locationSearchTable = storyboard!.instantiateViewController(withIdentifier: "LocationSearchTable") as! LocationSearchTable
        resultSearchController = UISearchController(searchResultsController: locationSearchTable)
        resultSearchController?.searchResultsUpdater = locationSearchTable
        let searchBar = resultSearchController!.searchBar
        searchBar.sizeToFit()
        searchBar.placeholder = "Search for places"
        navigationItem.titleView = resultSearchController?.searchBar
        resultSearchController?.hidesNavigationBarDuringPresentation = false
        resultSearchController?.dimsBackgroundDuringPresentation = true
        definesPresentationContext = true
        locationSearchTable.mapView = mapView

    }
}

extension SearchViewController : CLLocationManagerDelegate {
    private func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            locationManager.requestLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            let span = MKCoordinateSpanMake(0.05, 0.05)
            let region = MKCoordinateRegion(center: location.coordinate, span: span)
            mapView.setRegion(region, animated: true)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error:: \(error)")
    }
    
    
    func itemsDownloaded(items: NSArray) {
        print("tableView is working")
        feedItems = items
        print(feedItems)
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        let street_addrees: String =  selectedLocation!.street_address!
        let city: String =  selectedLocation!.city!
        let state: String =  selectedLocation!.state!
        let zipcode: String =  selectedLocation!.zipcode!

        Address = "\(street_addrees), \(city), \(state) \(zipcode)"
        
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(Address) {
            placemarks, error in
            let placemark = placemarks?.first
            let lat = placemark?.location?.coordinate.latitude
            let lon = placemark?.location?.coordinate.longitude
            print("Lat: \(lat), Lon: \(lon)")
        
            var poiCoodinates: CLLocationCoordinate2D = CLLocationCoordinate2D()
        
            poiCoodinates.latitude = CDouble(lat!)
            poiCoodinates.longitude = CDouble(lon!)

            
            let viewRegion: MKCoordinateRegion = MKCoordinateRegionMakeWithDistance(poiCoodinates, 750, 750)
            self.mapView.setRegion(viewRegion, animated: true)

            let pin: MKPointAnnotation = MKPointAnnotation()
            pin.coordinate = poiCoodinates
            self.mapView.addAnnotation(pin)
        
            self.myAnnotationWithCallout = pin
            
            //add title to the pin
            pin.title = self.selectedLocation?.event_name
            pin.subtitle = self.selectedLocation?.username
            
            

        }
    }
    
//     func mapView (_: MKMapView!, regionWillChangeAnimated_: animated)
//{
//    if ((myAnnotationWithCallout) != nil)
//    {
//    [mapView selectAnnotation: myAnnotationWithCallout animated:YES];
//    myAnnotationWithCallout = nil;
//    }
//    }
//    
//    
    func mapView(mapView: MKMapView!, annotationView: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        

        
        if control == annotationView.rightCalloutAccessoryView {
            performSegue(withIdentifier: "pinToAttendeeView", sender: self)
            
            print("Going to the next VC!")
        }
    }
    
}
