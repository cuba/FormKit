//
//  DateInputAccessoryView.swift
//  SafetyBoot
//
//  Created by Jacob Sikorski on 2017-03-30.
//  Copyright © 2017 Tamarai. All rights reserved.
//

import Foundation
import UIKit

protocol DateInputAccessoryViewDelegate {
    func datePickerSelectedToday()
    func datePickerDonePressed()
}

class DateInputAccessoryView: UIToolbar {
    var dateInputDelegate: DateInputAccessoryViewDelegate?
    var label: UILabel?
    var todayButton: UIBarButtonItem?
    var okButton: UIBarButtonItem?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViews()
    }
    
    func setupViews() {
        layer.position = CGPoint(x: self.frame.size.width/2, y: self.frame.size.height-20.0)
        barStyle = UIBarStyle.blackTranslucent
        tintColor = UIColor.white
        backgroundColor = UIColor.black
        
        // Set the buttons
        let todayButton = UIBarButtonItem(title: "Label.Today".localized(), style: UIBarButtonItemStyle.plain, target: self, action: #selector(datePickerSelectedToday))
        let okButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done, target: self, action: #selector(datePickerDonePressed))
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: self, action: nil)
        
        // Set the label
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: self.frame.size.width / 3, height: self.frame.size.height))
        label.font = UIFont(name: "Helvetica", size: 12)
        label.backgroundColor = UIColor.clear
        label.textColor = UIColor.white
        label.textAlignment = NSTextAlignment.center
        
        let textBtn = UIBarButtonItem(customView: label)
        
        self.todayButton = todayButton
        self.okButton = okButton
        self.label = label
        setItems([todayButton,flexSpace,textBtn,flexSpace,okButton], animated: true)
    }
    
    @objc func datePickerSelectedToday() {
        dateInputDelegate?.datePickerSelectedToday()
    }
    
    @objc func datePickerDonePressed() {
        dateInputDelegate?.datePickerDonePressed()
    }
}
