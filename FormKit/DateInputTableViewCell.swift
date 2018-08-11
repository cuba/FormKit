//
//  DateInputTableViewCell.swift
//  SafetyBoot
//
//  Created by Jacob Sikorski on 2017-03-24.
//  Copyright © 2017 Tamarai. All rights reserved.
//

import Foundation
import UIKit

public protocol DateFieldCellProvider: FormFieldCellProvider {
    func configure(with dateField: DateField)
}

open class DateInputTableViewCell: InputTableViewCell, DateFieldCellProvider {
    
    public private(set) var dateField: DateField?
    
    public override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        textField.inputView = dateTimePicker(mode: .dateAndTime)
        let accessoryView = DateInputAccessoryView(frame: CGRect(x: 0, y: self.frame.size.height/6, width: self.frame.size.width, height: 44.0))
        accessoryView.dateInputDelegate = self
        textField.inputAccessoryView = accessoryView
        textField.delegate = self
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open func configure(with field: DateField) {
        self.dateField = field
        label.text = field.label
        textField.text = field.value
        setupInputView(for: field)
    }
    
    @objc private func datePickerValueChanged(sender: UIDatePicker) {
        setDate(date: sender.date)
    }
    
    private func setupInputView(for field: DateField) {
        let datePicker = textField.inputView as? UIDatePicker
        datePicker?.date = field.date ?? Date()
        super.configure(with: field)
    }
    
    private func getDatePickerMode(field: DateField) -> UIDatePickerMode {
        switch field.type {
        case .date: return .date
        case .time: return .time
        case .dateTime: return .dateAndTime
        }
    }
    
    private func dateTimePicker(mode: UIDatePickerMode) -> UIDatePicker {
        let datePickerView = UIDatePicker()
        datePickerView.datePickerMode = mode
        datePickerView.addTarget(self, action: #selector(datePickerValueChanged), for: UIControlEvents.valueChanged)
        
        return datePickerView
    }
    
    private func setDate(date: Date) {
        dateField?.date = date
        textField.text = dateField?.value
    }
}

extension DateInputTableViewCell: DateInputAccessoryViewDelegate {
    func datePickerSelectedToday() {
        setDate(date: Date())
        textField.resignFirstResponder()
    }
    
    func datePickerDonePressed() {
        textField.resignFirstResponder()
    }
}

extension DateInputTableViewCell: UITextFieldDelegate {
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string.count <= 1 {
            return false
        } else {
            return true
        }
    }
    
    public func textFieldDidEndEditing(_ textField: UITextField) {
        if let field = dateField, let indexPath = self.indexPath {
            delegate?.valueChanged(for: field, at: indexPath)
        }
    }
}
