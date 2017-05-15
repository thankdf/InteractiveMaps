//
//  EditBoothViewController.swift
//  Maps
//
//  Created by yoho chen on 11/4/16.
//  Copyright © 2016 Team_Interactive_Maps. All rights reserved.
//
//  DatePicker Tutorial: www.youtube.com/watch?v=_ADJxJ7pjRk
//
//  Thanks Icons8.com for camera icon. link: icons8.com/web-app/11772/Screenshot-Filled
import UIKit

/* Delegate Comment: Declare Protocal and method signature in the children/sender/delegating/ class */

protocol DataSentDelegate {
    func userDidEditName(data:String, whichBooth: BoothShape)
    func userDidEditAbbrev(data:String, whichBooth: BoothShape)
    func userDidEditInfo(data:String, whichBooth: BoothShape)
    func userDidEditStartTime(data:String, whichBooth: BoothShape)
    func userDidEditEndTime(data:String, whichBooth: BoothShape)
    func userDidUploadPic(data:[UIImage], whichBooth: BoothShape)
    
}

class EditBoothViewController: UIViewController, UIImagePickerControllerDelegate,UINavigationControllerDelegate  {
    
    @IBOutlet weak var reviewButton: UIButton!
    {
        didSet
        {
            reviewButton.titleLabel?.adjustsFontSizeToFitWidth = true 
        }
    
    }
    
    @IBOutlet weak var nameLabel: UILabel!
    {
        didSet
        {
            nameLabel.adjustsFontSizeToFitWidth = true
        }
    }
    
    @IBOutlet weak var abbreviationLabel: UILabel!
    {
        didSet
        {
            abbreviationLabel.adjustsFontSizeToFitWidth = true
        }
    }
    
    @IBOutlet weak var startTimeLabel: UILabel!
    {
        didSet
        {
            startTimeLabel.adjustsFontSizeToFitWidth = true
        }
    }
    
    @IBOutlet weak var endTimeLabel: UILabel!
    {
        didSet
        {
            endTimeLabel.adjustsFontSizeToFitWidth = true
        }
    }
    
    @IBOutlet weak var infoLabel: UILabel!
    {
        didSet
        {
            infoLabel.adjustsFontSizeToFitWidth = true
        }
    }
    
    @IBOutlet weak var nameTextField: UITextField!
    
    @IBOutlet weak var abbreviationTextField: UITextField!
    
    @IBOutlet weak var startTimeTextField: UITextField!
    
    @IBOutlet weak var endTimeTextField: UITextField!
    
    @IBOutlet weak var infoTextField: UITextView!
    
    @IBOutlet weak var backButton: UIBarButtonItem!
    
    @IBOutlet weak var doneButton: UIBarButtonItem!
    
    /* Delegate Comment: instantiate an protocal object in this class, when u segue way in from the
     parentVC, set "this.delegate = parentVC.self" */
    
    var delegate: DataSentDelegate? = nil;
    var boothRef :BoothShape? = nil
    var name = ""
    var abbreviation = ""
    var info = ""
    var startTime = ""
    var endTime = ""
    var boothImages:[UIImage] = []
    var selectedLocation : LocationModel = LocationModel()
    
    let datePicker = UIDatePicker()
    
    @IBOutlet weak var screen: UIView!
    
    @IBOutlet weak var imageScrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.infoTextField.layer.cornerRadius = 5.0
        let widthfactor = self.view.bounds.width/screen.bounds.width
        let heightfactor = self.view.bounds.height/screen.bounds.height
        screen.frame.size = CGSize.init(width: screen.bounds.width * widthfactor, height: screen.bounds.height * heightfactor)
        for subview in screen.subviews
        {
            subview.frame = CGRect.init(origin: CGPoint.init(x: subview.frame.origin.x * widthfactor, y: subview.frame.origin.y * heightfactor), size: CGSize.init(width: subview.bounds.width * widthfactor, height: subview.bounds.height * heightfactor))
        }
        datePicker.datePickerMode = UIDatePickerMode.time
        
        //HTTP Request to retrieve booth detail information
        let ipAddress = "http://130.65.159.80/RetrieveBooth.php"
        let url = URL(string: ipAddress)
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        
        let postString = "boothID=\(selectedLocation.booth_id)"
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
                        let booth = parseJSON["booth"] as! [String: Any]
                        self.nameTextField.text = booth["booth_name"] as! String
                        self.abbreviationTextField.text = booth["booth_abbrev"] as! String
                        self.startTimeTextField.text = booth["start_time"] as! String
                        self.endTimeTextField.text = booth["end_time"] as! String
                        let infoText = booth["booth_info"] as! String
//                        self.infoTextField.text = infoText.trimmingCharacters(in: CharacterSet.init(charactersIn: ""))
                    
                        self.name = booth["booth_name"] as! String
                        self.abbreviation = booth["booth_abbrev"] as! String
                        self.startTime = booth["start_time"] as! String
                        self.endTime = booth["end_time"] as! String
                        self.info = booth["booth_info"] as! String
                    }
                }
                catch let error as Error?
                {
                    print("Found an error - \(String(describing: error))")
                }
                
        }).resume()
        
        //       // boothInfo.layer.shadowColor = UIColor.black.cgColor
        //        boothInfo.layer.shadowOffset = CGSize(width: 2.0, height: 2.0)
        //        boothInfo.layer.shadowOpacity = 1.0
        //        boothInfo.layer.shadowRadius = 2.0
        startTimePicker()
        endTimePicker()
        loadImages()
    }
    
    @IBAction func imageTapped(sender: UITapGestureRecognizer) {
        let imageView = sender.view as! UIImageView
        let newImageView = UIImageView(image: imageView.image)
        newImageView.frame = self.view.frame
        newImageView.backgroundColor = UIColor.black
        newImageView.contentMode = .scaleAspectFit
        newImageView.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissFullscreenImage))
        newImageView.addGestureRecognizer(tap)
        self.view.addSubview(newImageView)
    }
    
    func dismissFullscreenImage(sender: UITapGestureRecognizer) {
        sender.view?.removeFromSuperview()
    }
    
    @IBAction func AddImage(_ sender: UIButton) {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)
        
        actionSheet.view.tintColor = UIColor.black
        let camButton = UIAlertAction(title: "Camera", style: UIAlertActionStyle.default) { (libSelected) in
            
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) {
                let imagePicker = UIImagePickerController()
                imagePicker.delegate = self
                imagePicker.sourceType = UIImagePickerControllerSourceType.camera;
                imagePicker.allowsEditing = false
                self.present(imagePicker, animated: true, completion: nil)
            }
        }
        
        let libButton = UIAlertAction(title: "Choose from Album", style: UIAlertActionStyle.default) { (libSelected) in
            
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary) {
                let imagePicker = UIImagePickerController()
                imagePicker.delegate = self
                imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary;
                imagePicker.allowsEditing = true
                self.present(imagePicker, animated: true, completion: nil)
            }
        }
        
        let cancelButton = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel) {
            (libSelected) in
            
        }
        actionSheet.addAction(camButton)
        actionSheet.addAction(libButton)
        actionSheet.addAction(cancelButton)
        self.present(actionSheet, animated: true, completion: nil)
        
    }
    
    //after choosing the image
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [String : Any])
    {
        let chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage //2
        //imageDisplay.contentMode = .scaleAspectFill
        // imageDisplay.image = chosenImage
        boothImages.append(chosenImage)
        loadImages()//for fun
        
        
        dismiss(animated:true, completion: nil)
    }
    
    //load ImageArray into the scroll view
    func loadImages(){
        
        for i in 0..<boothImages.count{
            
            let imageView = UIImageView()
            //reverse order so that newest pic in front
            imageView.image = boothImages[boothImages.count-i-1]
            imageView.contentMode = .scaleAspectFill
            imageView.isUserInteractionEnabled = true
            
            let xPosition = self.view.frame.width * CGFloat(i)
            imageView.frame = CGRect(x: xPosition, y: self.view.frame.origin.y, width: self.imageScrollView.frame.width, height: self.imageScrollView.frame.height)
            
            let longPressImage = UILongPressGestureRecognizer(target: self, action: #selector(deleteImage))
            imageView.addGestureRecognizer(longPressImage)
            
            imageScrollView.contentSize.width = imageScrollView.frame.width * CGFloat(i + 1)
            imageScrollView.addSubview(imageView)
            
        }
    }
    
    
    func deleteImage(sender: UIGestureRecognizer){
        
        // if long press on user
        if sender.state == UIGestureRecognizerState.began {
            
            let alertController = UIAlertController(title: "Delete this photo?", message: nil , preferredStyle: .alert)
            
            //cancel button
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { action in
                alertController.dismiss(animated: true, completion: nil)
            }
            
            //delete button
            let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { action in
                //get the current page on scrollView
                let page = Int(self.imageScrollView.contentOffset.x / self.imageScrollView.frame.size.width);
                
                //remove from array
                self.boothImages.remove(at: self.boothImages.count - page - 1)
                
                //remove all subview (inefficient but work)
                for view in self.imageScrollView.subviews{
                    if view .isKind(of: UIImageView.self) {
                        view.removeFromSuperview()
                    }
                }
                //reload
                self.loadImages()
            }
            
            alertController.addAction(cancelAction)
            alertController.addAction(deleteAction)
            self.present(alertController, animated: true)
            
            
            
        }
        
        
    }
    
    /* Date Picker */
    func startTimePicker(){
        
        //toolbar
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        //bar button item
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(startTimeDonePressed))
        toolbar.setItems([doneButton], animated: false)
        
        startTimeTextField.inputAccessoryView = toolbar
        
        //assigning date picker to textfield
        startTimeTextField.inputView = datePicker
    }
    
    func startTimeDonePressed(){
        
        // format date
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .none
        dateFormatter.timeStyle = .short
        
        
        startTimeTextField.text = dateFormatter.string(from: datePicker.date)
        self.view.endEditing(true)
        
    }
    
    
    func endTimePicker(){
        
        //toolbar
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        //bar button item
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(endTimeDonePressed))
        toolbar.setItems([doneButton], animated: false)
        
        endTimeTextField.inputAccessoryView = toolbar
        
        //assigning date picker to textfield
        endTimeTextField.inputView = datePicker
    }
    
    func endTimeDonePressed(){
        
        // format date
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .none
        dateFormatter.timeStyle = .short
        
        
        endTimeTextField.text = dateFormatter.string(from: datePicker.date)
        self.view.endEditing(true)
    }
    
    
    //    //inorder to save/share photo
    //    func saveshare(){
    //        let myMessage = "Hello world"
    //        let activityVC = UIActivityViewController(activityItems: [myMessage], applicationActivities: nil)
    //        self.present(activityVC, animated: true, completion: nil)
    //    }
    
    
    // Done button clicked
    
    @IBAction func save(_ sender: UIBarButtonItem)
    {
        UserDefaults.standard.set(0, forKey: "boothID")
        
        //HTTP Request to save booth detail information
        let ipAddress = "http://130.65.159.80/SaveBooth.php"
        let url = URL(string: ipAddress)
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        
        let postString = "boothID=\(UserDefaults.standard.integer(forKey: "boothID"))&booth_info=\(infoTextField.text!)&booth_name=\(nameTextField.text!)&start_time=\(startTimeTextField.text!)&end_time=\(endTimeTextField.text!)&booth_abbrev=\(abbreviationTextField.text!)"
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
                        self.updateDelegate()
                        self.displayAlert(parseJSON["message"] as! String)
                    }
                }
                catch let error as Error?
                {
                    print("Found an error - \(String(describing: error))")
                    self.displayAlert("Was not able to successfully save booth.")
                }
                
        }).resume()
    }

    func updateDelegate()
    {
        if delegate != nil
        {
            // check name change
            if nameTextField.text != name
            {
                if let newName = nameTextField.text
                {
                    delegate?.userDidEditName(data: newName, whichBooth: boothRef!)
                }
                else{
                    print("Name not changed.")
                }
                
            }
            
            // check info change
            if infoTextField.text != info
            {
                if let newInfo = infoTextField.text
                {
                    delegate?.userDidEditInfo (data: newInfo, whichBooth: boothRef!)
                }
                else
                {
                    print("Info not changed.")
                }
                
            }
            
            // check start time change
            if startTimeTextField.text != startTime
            {
                if let newStartTime = startTimeTextField.text
                {
                    delegate?.userDidEditStartTime(data: newStartTime, whichBooth: boothRef!)
                }
                else
                {
                    print("Start time not changed.")
                }
                
            }
            
            // check end time change
            if endTimeTextField.text != endTime
            {
                if let newEndTime = endTimeTextField.text
                {
                    delegate?.userDidEditEndTime(data: newEndTime, whichBooth: boothRef!)
                }
                else
                {
                    print("End time not changed.")
                }
                
            }
            
            // check info change
            if abbreviationTextField.text != info
            {
                if let newAbbreviation = abbreviationTextField.text
                {
                    delegate?.userDidEditInfo(data: newAbbreviation, whichBooth: boothRef!)
                }
                else{
                    print("Abbreviation not changed.")
                }
                
            }
            
            //save photo
            if (1==1) //IF UPLOADED photo, add boolean later
            {
                delegate?.userDidUploadPic(data: boothImages, whichBooth:boothRef!)
                
            }

        }
    }
    

    @IBAction func cancelPressed(_ sender: UIBarButtonItem) {
        UserDefaults.standard.set(0, forKey: "boothID")
        self.presentingViewController!.dismiss(animated: true, completion: nil) //To dismiss itself
    }
    
    @IBAction func unwindFromReviewToInfo(segue: UIStoryboardSegue) {
        
    }
    
    
    // To dismiss keyboard
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    private func displayAlert(_ message: String)
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
    
    
    
}
