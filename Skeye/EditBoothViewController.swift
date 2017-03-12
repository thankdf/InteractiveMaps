//
//  EditBoothViewController.swift
//  Maps
//
//  Created by yoho chen on 11/4/16.
//  Copyright © 2016 Team_Interactive_Maps. All rights reserved.
//

import UIKit

/* Delegate Comment: Declare Protocol and method signature in the children/sender/delegating/ class */

protocol DataSentDelegate {
    func userDidEditName(data:String, whichBooth: BoothShape)
    func userDidEditInfo(data:String, whichBooth: BoothShape)
    func userDidUploadPic(data:UIImage, whichBooth: BoothShape)
}

class EditBoothViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate
{
    
    /* Delegate Comment: instantiate an protocal object in this class, when u segue way in from the
     parentVC, set "this.delegate = parentVC.self" */
    var delegate: DataSentDelegate? = nil;
    
    var boothRef : BoothShape? = nil
    var name: String = ""
    var info: String = ""
    var image: UIImage? = nil
    var nameEdit = false
    var infoEdit = false
    
    @IBOutlet weak var boothName: UITextField!
    @IBOutlet weak var boothInfo: UITextField!
    @IBOutlet weak var imagePicked: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        boothName.text = name
        boothInfo.text = info
        imagePicked.image = image
    }
    
    // Done button clicked
    @IBAction func DoneBtnPressed(_ sender: UIButton) {
        if delegate != nil
        {
            
            if nameEdit
            {
                if let newName = boothName.text
                {
                    delegate?.userDidEditName(data: newName, whichBooth: boothRef!)
                }
                else{
                    print("null value for name")
                }
                
            }
            
            if infoEdit
            {
                if let newInfo = boothInfo.text
                {
                    delegate?.userDidEditInfo (data: newInfo, whichBooth: boothRef!)
                }
                else{
                    print("null value for info")
                }
                
            }
            
            //save photo
            if let newPic = imagePicked.image{
                delegate?.userDidUploadPic(data: newPic, whichBooth:boothRef!)
            }
        }
        
        self.presentingViewController!.dismiss(animated: false, completion: nil) //To dismiss popover
    }
    
    @IBAction func nameChanged(_ sender: UITextField) {
        nameEdit = true
        print("\(boothName.text)")
    }
    
    @IBAction func infoChanged(_ sender: UITextField) {
        infoEdit = true
    }
    // Use Camera
    @IBAction func openCameraButton(sender: AnyObject) {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.camera;
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    // Use Camera roll
    @IBAction func openPhotoLibraryButton(sender: AnyObject) {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary;
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    
    //display the chosen image
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any])
    {
        let chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage //2
        imagePicked.contentMode = .scaleAspectFit
        imagePicked.image = chosenImage
        
        dismiss(animated:true, completion: nil)
    }
}
