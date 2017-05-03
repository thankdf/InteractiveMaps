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
    
    @IBOutlet weak var EndDateText: UITextField!
    @IBOutlet weak var StartDateText: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        startDatePicker()
        endDatePicker()
    }
    
    /* Date Picker */
    func startDatePicker(){
        
        datePicker.datePickerMode = .date
        
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
       // dateFormatter.timeStyle = .short
        
        StartDateText.text = dateFormatter.string(from: datePicker.date)
        self.view.endEditing(true)
        
        EndDateText.text = dateFormatter.string(from: datePicker.date)
        self.view.endEditing(true)
    }
    
    
    func endDatePicker(){
        
        datePicker.datePickerMode = .date
        
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
        // dateFormatter.timeStyle = .short
        
         EndDateText.text = dateFormatter.string(from: datePicker.date)
        self.view.endEditing(true)
    }

    
}
