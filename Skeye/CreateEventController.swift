//
//  CreateEventController.swift
//  Skeye
//
//  Created by Sandeep Kaur on 5/3/17.
//  Copyright © 2017 Team_Parking. All rights reserved.
//

import Foundation
import UIKit

class CreateEventController: UIViewController {
    
    let datePicker = UIDatePicker()
    let timePicker = UIDatePicker()

    
    @IBOutlet weak var screen: UIView!
    @IBOutlet weak var EndDateText: UITextField!
    @IBOutlet weak var StartDateText: UITextField!

    @IBOutlet weak var StartTimeText: UITextField!
    @IBOutlet weak var EndTimeText: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(self.view.frame.size)
        print(screen.frame.size)
        let widthfactor = self.view.frame.width/screen.frame.width
        let heightfactor = self.view.frame.height/screen.frame.height
        print(widthfactor)
        print(heightfactor)
        screen.frame.size = CGSize.init(width: screen.bounds.width * widthfactor, height: screen.bounds.height * heightfactor)
        for subview in screen.subviews
        {
            subview.frame = CGRect.init(origin: CGPoint.init(x: subview.frame.origin.x * widthfactor, y: subview.frame.origin.y * heightfactor), size: CGSize.init(width: subview.bounds.width * widthfactor, height: subview.bounds.height * heightfactor))
        }
        
        startDatePicker()
        endDatePicker()
        
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
        
        // formate date
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .short

        
         EndDateText.text = dateFormatter.string(from: datePicker.date)
        self.view.endEditing(true)
    }
    
}
