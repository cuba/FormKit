//
//  TextInputTableViewCell.swift
//  retail
//
//  Created by Jacob Sikorski on 2016-06-11.
//  Copyright © 2016 Jacob Sikorski. All rights reserved.
//

import UIKit

protocol TextInputTableViewCellDelegate: class {
    func textInputTableViewCell(_ cell: TextInputTableViewCell, didUpdateField field: TextInputField)
}

public protocol TextInputTableViewDelegate: class {
    func textFieldShouldReturn(for cell: TextInputTableViewCell) -> Bool
    func textFieldDidBeginEditing(_ textField: UITextField, for cell: TextInputTableViewCell)
    func textFieldDidEndEditing(_ textField: UITextField, for cell: TextInputTableViewCell)
}

public protocol StringFieldCellProvider: FormFieldCellProvider {
    func configure(with field: StringField)
}

public protocol NumberFieldCellProvider: FormFieldCellProvider {
    func configure(with field: NumberField)
}

open class TextInputTableViewCell: InputTableViewCell, StringFieldCellProvider, NumberFieldCellProvider {
    weak var textInputCellDelegate: TextInputTableViewDelegate?
    weak var delegate: TextInputTableViewCellDelegate?
    private(set) var inputField: TextInputField?
    
    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        textField.delegate = self
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func configure(with field: StringField) {
        self.configure(with: field as TextInputField)
        
        textField.autocapitalizationType = field.autocapitalizationType
        textField.autocorrectionType = field.autocorrectionType
        textField.keyboardType = field.keyboardType
        
        switch field.type {
        case .password:
            textField.isSecureTextEntry = true
            
            if #available(iOSApplicationExtension 11.0, *) {
                textField.textContentType = field.textContentType ?? .password
            } else {
                textField.textContentType = field.textContentType ?? UITextContentType(rawValue: "")
                // Fallback on earlier versions
            }
        default:
            textField.isSecureTextEntry = false
            textField.textContentType = field.textContentType ?? UITextContentType(rawValue: "")
        }
    }
    
    public func configure(with field: NumberField) {
        self.configure(with: field as TextInputField)
        textField.isSecureTextEntry = false
        textField.autocorrectionType = .no
        textField.autocapitalizationType = .none
        
        switch field.type {
        case .integer: textField.keyboardType = .numberPad
        case .decimal: textField.keyboardType = .decimalPad
        }
    }
    
    private func configure(with field: TextInputField) {
        super.configure(with: field)
        inputField = field
        textField.isSecureTextEntry = false
    }
}

extension TextInputTableViewCell: UITextFieldDelegate {
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        switch textField.keyboardType {
        case .numberPad:
            return string.isEmpty || Int(string) != nil
        case .decimalPad:
            return string.isEmpty || Double(string) != nil || (string == "." && textField.text?.firstIndex(of: ".") == nil)
        default:
            return true
        }
    }
    
    public func textFieldDidBeginEditing(_ textField: UITextField) {
        textInputCellDelegate?.textFieldDidBeginEditing(textField, for: self)
    }
    
    public func textFieldDidEndEditing(_ textField: UITextField) {
        textInputCellDelegate?.textFieldDidEndEditing(textField, for: self)
        inputField?.set(value: textField.text)
        
        guard let field = inputField else {
            return
        }
        
        delegate?.textInputTableViewCell(self, didUpdateField: field)
    }
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return textInputCellDelegate?.textFieldShouldReturn(for: self) ?? true
    }
    
    public func textFieldShouldClear(_ textField: UITextField) -> Bool {
        return true
    }
}
