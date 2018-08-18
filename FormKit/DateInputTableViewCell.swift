//
//  DateInputTableViewCell.swift
//  SafetyBoot
//
//  Created by Jacob Sikorski on 2017-03-24.
//  Copyright © 2017 Tamarai. All rights reserved.
//

import Foundation
import UIKit

protocol DateInputTableViewCellDelegate: class {
    func dateInputTableViewCell(_ cell: DateInputTableViewCell, didUpdateField field: DateField)
}

public protocol DateFieldCellProvider: FormFieldCellProvider {
    func configure(with dateField: DateField)
}

open class DateInputTableViewCell: InputTableViewCell, DateFieldCellProvider {
    weak var delegate: DateInputTableViewCellDelegate?
    public private(set) var dateField: DateField?
    
    public override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
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
        informDelegate()
    }
    
    private func setupInputView(for field: DateField) {
        super.configure(with: field)
        let datePicker = textField.inputView as? UIDatePicker
        datePicker?.date = field.date ?? Date()
        
        let accessoryView = field.type.makeAccessoryView(for: frame)
        accessoryView.dateInputDelegate = self
        textField.inputAccessoryView = accessoryView
        textField.inputView = dateTimePicker(mode: field.type.datePickerMode)
        textField.autocorrectionType = .no
        textField.autocapitalizationType = .none
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
    
    private func informDelegate() {
        guard let field = dateField else { return }
        delegate?.dateInputTableViewCell(self, didUpdateField: field)
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
        informDelegate()
    }
}

private extension DateFieldType {
    var datePickerMode: UIDatePickerMode {
        switch self {
        case .date:     return .date
        case .dateTime: return .dateAndTime
        case .time:     return .time
        }
    }
    
    func makeAccessoryView(for frame: CGRect) -> DateInputAccessoryView {
        let accessoryView = DateInputAccessoryView(frame: CGRect(x: 0, y: 0, width: frame.size.width, height: 44.0))
        
        switch self {
        case .time, .dateTime:
            accessoryView.todayButton?.title = "Label.Now".localized()
        default:
            accessoryView.todayButton?.title = "Label.Today".localized()
        }
        
        return accessoryView
    }
}
