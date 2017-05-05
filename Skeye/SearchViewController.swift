//
//  SearchViewController.swift
//  Skeye
//
//  Created by Sandeep Kaur on 3/19/17.
//  Copyright © 2017 Team Skeye. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation


class SearchViewController : UIViewController {
    
    var resultSearchController:UISearchController? = nil
    
    let locationManager = CLLocationManager()
    var selectedLocation : LocationModel?
    
    @IBOutlet weak var mapView: MKMapView!
    
    @IBAction func CreateMap(_ sender: Any) {
        performSegue(withIdentifier: "createEventSegue", sender: self)
        
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
    
    override func viewDidAppear(_ animated: Bool) {

        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString("1 Infinite Loop, CA, USA") {
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
        
            //add title to the pin
            pin.title = self.selectedLocation?.event_name
        }
    }
    
    
}
