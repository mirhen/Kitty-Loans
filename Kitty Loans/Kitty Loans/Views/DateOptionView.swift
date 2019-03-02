//
//  DateOptionView.swift
//  Houndify Chat
//
//  Created by Miriam Haart on 3/3/18.
//  Copyright © 2018 Miriam Haart. All rights reserved.
//

import UIKit

class DateOptionView: UIView {
    
    @IBOutlet var datePicker: UIDatePicker!
    
    
    // MARK: - Properties
    weak var delegate: DateOptionViewDelegate?
    var selectedDate: Date?
    
    override func draw(_ rect: CGRect) {
        
        datePicker.maximumDate = Date()
    }
    @IBAction func nextButtonTapped(_ sender: UIButton) {
        print("next button tapped")
        delegate?.didSendResponse(selectedDate, on: self)
    }
    @IBAction func skipButtonTapped(_ sender: UIButton) {
        print("skip button tapped")
        delegate?.didSendResponse(selectedDate, on: self)
    }
    
    @IBAction func datePickerTapped(_ sender: UIDatePicker) {
        print("date picker tapped")
        
        selectedDate = datePicker.date
        
    }
}
