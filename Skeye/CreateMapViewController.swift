//
//  CreateMapViewController.swift
//  Skeye
//
//  Created by Kevin Dang on 5/4/17.
//  Copyright © 2017 Team_Parking. All rights reserved.
//

import UIKit

class CreateMapViewController: UIViewController
{
    var selectedLocation : LocationModel?
    let datePicker = UIDatePicker()
    let timePicker = UIDatePicker()
    
    @IBOutlet weak var eventlabel: UILabel!
    {
        didSet
        {
            eventlabel.adjustsFontSizeToFitWidth = true
        }
    }
    @IBOutlet weak var screen: UIView!
    
    @IBOutlet weak var eventName: UITextField!
    @IBOutlet weak var streetAddress: UITextField!
    @IBOutlet weak var state: UITextField!
    @IBOutlet weak var city: UITextField!
    @IBOutlet weak var zipCode: UITextField!
    @IBOutlet weak var StartDateText: UITextField!
    @IBOutlet weak var EndDateText: UITextField!
    
    
    @IBOutlet weak var saveButton: UIButton!
    {
        didSet
        {
            saveButton.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(save)))
        }
    }
    @IBOutlet weak var backButton: UIButton!
    {
        didSet
        {
            backButton.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(back)))
        }
    }
    
    var address_id = 0;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let widthfactor = self.view.bounds.width/screen.bounds.width
        let heightfactor = self.view.bounds.height/screen.bounds.height
        screen.frame.size = CGSize.init(width: screen.bounds.width * widthfactor, height: screen.bounds.height * heightfactor)
        for subview in screen.subviews
        {
            subview.frame = CGRect.init(origin: CGPoint.init(x: subview.frame.origin.x * widthfactor, y: subview.frame.origin.y * heightfactor), size: CGSize.init(width: subview.bounds.width * widthfactor, height: subview.bounds.height * heightfactor))
        }
        startDatePicker()
        endDatePicker()
        if(selectedLocation?.event_id != nil)
        {
            //HTML Request
            let ipAddress = "http://130.65.159.80/LoadMapData.php"
            let url = URL(string: ipAddress)
            var request = URLRequest(url: url!)
            request.httpMethod = "POST"
            let postString = "mapID=\((selectedLocation?.event_id)!)"
            request.httpBody = postString.data(using: String.Encoding.utf8)
            URLSession.shared.dataTask(with: request, completionHandler:
                {
                    (data, response, error) -> Void in
                    if(error != nil)
                    {
                        print("error=\(String(describing: error))\n")
                        return
                    }
                    do
                    {
                        let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? [String: Any]
                        if let parseJSON = json
                        {
                            let resultValue: String = parseJSON["status"] as! String
                            print("result: \(resultValue)\n")
                            
                            if(resultValue == "success")
                            {
                                let mapData = parseJSON["map"] as! [String: Any]
                                let addressData = parseJSON["address"] as! [String: Any]
                                self.eventName.text = mapData["event_name"] as? String
                                self.streetAddress.text = addressData["street_address"] as? String
                                self.city.text = addressData["city"] as? String
                                self.state.text = addressData["state"] as? String
                                self.zipCode.text = addressData["zipcode"] as? String
                                self.address_id = Int((addressData["address_id"] as? String)!)!
                                if(!((mapData["start_date"] as? String)! == "" && (mapData["start_time"] as? String)! == ""))
                                {
                                    self.StartDateText.text = (mapData["start_date"] as? String)! + ", " + (mapData["start_time"] as? String)!
                                }
                                if(!((mapData["end_date"] as? String)! == "" && (mapData["end_time"] as? String)! == ""))
                                {
                                    self.EndDateText.text = (mapData["end_date"] as? String)! + ", " + (mapData["end_time"] as? String)!
                                }
                            }
                        }
                    }
                    catch let error as Error?
                    {
                        print("Found an error - \(String(describing: error))")
                    }
                    
            }).resume()
   
        }
    }
    
    /* Date Picker */
    func startDatePicker(){
        
        datePicker.minimumDate = Date()
        
        
        
        //toolbar
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        //bar button item
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(startDateDonePressed))
        toolbar.setItems([doneButton], animated: false)
        
        StartDateText.inputAccessoryView = toolbar
        
        //assigning date picker to textfield
        StartDateText.inputView = datePicker
    }
    
    func startDateDonePressed(){
        
        // formate date
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .short
        
        
        StartDateText.text = dateFormatter.string(from: datePicker.date)
        self.view.endEditing(true)
        
    }
    
    
    func endDatePicker(){
        
        // datePicker.datePickerMode = .date
        datePicker.minimumDate = Date()
        
        //toolbar
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        //bar button item
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(endDateDonePressed))
        toolbar.setItems([doneButton], animated: false)
        
        EndDateText.inputAccessoryView = toolbar
        
        //assigning date picker to textfield
        EndDateText.inputView = datePicker
    }
    
    func endDateDonePressed(){
        
        // format date
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .short
        
        
        EndDateText.text = dateFormatter.string(from: datePicker.date)
        self.view.endEditing(true)
    }
    
    func save()
    {
        if(eventName.text! == "" || streetAddress.text! == "" || state.text! == "" || city.text! == "" || zipCode.text! == "" || StartDateText.text! == "" || EndDateText.text! == "")
        {
            displayAlertFailure("One or more fields are empty. Try again.")
        }
        else
        {
            let startDate = StartDateText.text!.substring(to: (StartDateText.text!.range(of: ",", options: .backwards)?.lowerBound)!)
            let endDate = EndDateText.text!.substring(to: (EndDateText.text!.range(of: ",", options: .backwards)?.lowerBound)!)
            let startTime = StartDateText.text!.substring(from: StartDateText.text!.index(startDate.endIndex, offsetBy: 3))
            let endTime = EndDateText.text!.substring(from: EndDateText.text!.index(endDate.endIndex, offsetBy: 3))
            
            var event_id: Int
            if(selectedLocation?.event_id == nil)
            {
                event_id = 0
            }
            else
            {
                event_id = (selectedLocation?.event_id)!
            }
            
            //HTML Request
            let ipAddress = "http://130.65.159.80/SaveMapInfo.php"
            let url = URL(string: ipAddress)
            var request = URLRequest(url: url!)
            request.httpMethod = "POST"
            let postString = "event_name=\(eventName.text!)&street_address=\(streetAddress.text!)&city=\(city.text!)&state=\(state.text!)&zipcode=\(zipCode.text!)&start_date=\(startDate)&end_date=\(endDate)&start_time=\(startTime)&end_time=\(endTime)&event_id=\(event_id)&address_id=\(address_id)&username=\(UserDefaults.standard.string(forKey: "username")!)"
            print(postString)
            request.httpBody = postString.data(using: String.Encoding.utf8)
            URLSession.shared.dataTask(with: request, completionHandler:
                {
                    (data, response, error) -> Void in
                    if(error != nil)
                    {
                        print("error=\(String(describing: error))\n")
                        return
                    }
                    do
                    {
                        let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? NSDictionary
                        if let parseJSON = json
                        {
                            let resultValue: String = parseJSON["status"] as! String
                            print("result: \(resultValue)\n")
                            let messageToDisplay = parseJSON["message"] as! String!
                            if(resultValue == "success")
                            {
                                
                                if(self.selectedLocation?.event_id == nil)
                                {
                                    event_id = (parseJSON["mapID"] as? Int)!
                                    DispatchQueue.main.async
                                    {
                                        self.displayAlertNew(messageToDisplay!, event_id)
                                    }
                                }
                                else
                                {
                                    DispatchQueue.main.async
                                    {
                                        self.displayAlertOld(messageToDisplay!)
                                    }
                                }
                            }
                            else
                            {
                                DispatchQueue.main.async
                                {
                                    self.displayAlertFailure(messageToDisplay!)
                                }
                            }
                        }
                    }
                    catch let error as Error?
                    {
                        print("Found an error - \(String(describing: error))")
                    }
                    
            }).resume()
        }
    }
    
    private func displayAlertOld(_ message: String)
    {
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: UIAlertControllerStyle.alert)
        let ok = UIAlertAction(title: "OK", style: UIAlertActionStyle.default)
        {
            (action:UIAlertAction) in
            self.dismiss(animated: true, completion: nil)
        }
        alert.addAction(ok)
        self.present(alert, animated: true, completion: nil)
    }
    
    private func displayAlertNew(_ message: String, _ id: Int)
    {
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: UIAlertControllerStyle.alert)
        let ok = UIAlertAction(title: "OK", style: UIAlertActionStyle.default)
        {
            (action:UIAlertAction) in
            let rootVC = UIApplication.shared.keyWindow?.rootViewController
            let mapViewController = rootVC!.storyboard!.instantiateViewController(withIdentifier: "MapViewController") as! MapViewController
            mapViewController.selectedLocation = LocationModel()
            mapViewController.selectedLocation?.event_id = id
            self.present(mapViewController, animated: true, completion: nil)
        }
        alert.addAction(ok)
        self.present(alert, animated: true, completion: nil)
    }
    
    private func displayAlertFailure(_ message: String)
    {
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: UIAlertControllerStyle.alert)
        let ok = UIAlertAction(title: "OK", style: UIAlertActionStyle.default)
        alert.addAction(ok)
        self.present(alert, animated: true, completion: nil)
    }
    
    func back(gesture: UITapGestureRecognizer)
    {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        self.view.endEditing(true)
        
    }
}
