//
//  AddReviewViewController.swift
//  Skeye
//
//  Created by yoho chen on 4/26/17.
//  Copyright © 2017 Team_Parking. All rights reserved.
//

import UIKit

class AddReviewViewController: UIViewController, UIImagePickerControllerDelegate,UINavigationControllerDelegate, UITextViewDelegate {
    
    @IBOutlet weak var reviewTextView: UITextView!

    @IBOutlet weak var image1: UIImageView!
    
    @IBOutlet weak var image2: UIImageView!
    
    @IBOutlet weak var image3: UIImageView!
    
    var newReview : Review?
    
    var reviewImage = [UIImage?](repeating:nil, count:3)
    //var imageSet = [Bool](repeating: false, count: 3)


    
    override func viewDidLoad() {
        super.viewDidLoad()
        reviewTextView.delegate = self
        reviewTextView.text = "Say something.."
        reviewTextView.textColor = UIColor.lightGray
        
        image1.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(addNewImage)))
        image2.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(addNewImage)))
        image3.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(addNewImage)))
        

    }

    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Say something.."
            textView.textColor = UIColor.lightGray
        }
    }

    var imageSelected = 1
    
    func addNewImage(sender: UITapGestureRecognizer)
    {
        imageSelected = (sender.view?.tag)!

        
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
        let chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        //imageDisplay.contentMode = .scaleAspectFill
        // imageDisplay.image = chosenImage
       // boothImages.append(chosenImage)
       // loadImages()//for fun

        if let imageSlot = self.view.viewWithTag(imageSelected) as? UIImageView
        {
            imageSlot.image = chosenImage
            switch imageSelected
            {
                case 1:
                    //imageSet[0] = true
                    reviewImage[0] = chosenImage
                case 2:
                    //imageSet[1] = true
                    reviewImage[1] = chosenImage
                case 3:
                    //imageSet[2] = true
                    reviewImage[2] = chosenImage
                default:
                    print("error on picking review image")
            }
        }

        dismiss(animated:true, completion: nil)
    }
    
    




    
    
    // To dismiss keyboard
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

 
    
    
}


