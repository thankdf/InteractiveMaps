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


class SearchViewController : UIViewController {
    
    var resultSearchController:UISearchController? = nil
    var myAnnotationWithCallout:MKPointAnnotation? = nil
    var feedItems: NSArray = NSArray()
    var Address: String = ""
    var annotation:MKAnnotation!
    var eventcallout: EventCalloutView? = nil
    var detailButton: UIButton? = nil
    let locationManager = CLLocationManager()
    var selectedLocation : LocationModel?
    
    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var backButton: UIButton!
    {
        didSet
        {
            backButton.titleLabel?.adjustsFontSizeToFitWidth = true
            backButton.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(backButtonPressed)))
            backButton.isHidden = true
        }
    }
    
    @IBAction func backButtonPressed(_ gesture: UITapGestureRecognizer)
    {
        let rootVC = UIApplication.shared.keyWindow?.rootViewController
        let searchController = rootVC!.storyboard!.instantiateViewController(withIdentifier: "TabBarController")
        self.present(searchController, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        backButton.isHidden = true
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
        
        
        addAnnotation(for: mapView.centerCoordinate)
        
        if((eventcallout?.didTapDetailsButton(detailButton!)) != nil){
            
            let rootVC = UIApplication.shared.keyWindow?.rootViewController
            let searchController = rootVC!.storyboard!.instantiateViewController(withIdentifier: "TabBarController")
            
            self.present(searchController, animated: true, completion: nil)
        }
    }
    func didTapButton(_ sender: UIButton) {
        addAnnotation(for: mapView.centerCoordinate)
    }
    
    
    //        let geocoder = CLGeocoder()
    //        geocoder.geocodeAddressString(Address) {
    //            placemarks, error in
    //            let placemark = placemarks?.first
    //            let lat = placemark?.location?.coordinate.latitude
    //            let lon = placemark?.location?.coordinate.longitude
    //            print("Lat: \(lat), Lon: \(lon)")
    //
    //            var poiCoodinates: CLLocationCoordinate2D = CLLocationCoordinate2D()
    //
    //            poiCoodinates.latitude = CDouble(lat!)
    //            poiCoodinates.longitude = CDouble(lon!)
    //
    //
    //            let viewRegion: MKCoordinateRegion = MKCoordinateRegionMakeWithDistance(poiCoodinates, 750, 750)
    //            self.mapView.setRegion(viewRegion, animated: true)
    //
    //            let pin: MKPointAnnotation = MKPointAnnotation()
    //            pin.coordinate = poiCoodinates
    //            self.mapView.addAnnotation(pin)
    //
    //            self.myAnnotationWithCallout = pin
    //
    //            //add title to the pin
    //            pin.title = self.selectedLocation?.event_name
    //            pin.subtitle = self.selectedLocation?.username
    let geocoder = CLGeocoder()
    
    
    func addAnnotation(for coordinate: CLLocationCoordinate2D) {
        
        if((selectedLocation) != nil)
        {
            let street_addrees: String =  selectedLocation!.street_address!
            let city: String =  selectedLocation!.city!
            let state: String =  selectedLocation!.state!
            let zipcode: String =  selectedLocation!.zipcode!
            
            Address = "\(street_addrees), \(city), \(state) \(zipcode)"
            
            
            geocoder.geocodeAddressString(Address)  { placemarks, error in
                if let placemark = placemarks?.first {
                    let lat = placemark.location?.coordinate.latitude
                    let lon = placemark.location?.coordinate.longitude
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
                    pin.subtitle = self.Address
                    self.backButton.isHidden = false
                }
                
            }
            
        }
    }
}


extension SearchViewController : CLLocationManagerDelegate, MKMapViewDelegate {
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
    
    
    
    /// show custom annotation view
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation { return nil }
        
        let customAnnotationViewIdentifier = "MyAnnotation"
        
        var pin = mapView.dequeueReusableAnnotationView(withIdentifier: customAnnotationViewIdentifier)
        if pin == nil {
            pin = CustomAnnotationView(annotation: annotation, reuseIdentifier: customAnnotationViewIdentifier)
        } else {
            pin?.annotation = annotation
        }
        
        
        return pin
    }
    
    //    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
    //        performSegue(withIdentifier: "pinToAttendeeView", sender: nil)
    //    }
    
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView){
        performSegue(withIdentifier: "pinToAttendeeView", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "pinToAttendeeView"
        {
            // Get reference to the destination view controller
            let destViewController  = segue.destination as! AttendeeMapViewController
            // Set the property to the selected location so when the view for
            // detail view controller loads, it can access that property to get the feeditem obj
            destViewController.selectedLocation = selectedLocation
            
            //            let rootVC = UIApplication.shared.keyWindow?.rootViewController
            //            let searchController = rootVC!.storyboard!.instantiateViewController(withIdentifier: "AttendeeMapViewController")
            //
            //            self.present(searchController, animated: true, completion: nil)
            
        }
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        
        
    }
    
    
}
