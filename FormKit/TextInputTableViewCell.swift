//
//  TextInputTableViewCell.swift
//  retail
//
//  Created by Jacob Sikorski on 2016-06-11.
//  Copyright © 2016 Jacob Sikorski. All rights reserved.
//

import UIKit

public protocol TextInputTableViewDelegate: class {
    func textFieldShouldReturn(for cell: TextInputTableViewCell) -> Bool
    func textFieldDidBeginEditing(_ textField: UITextField, for cell: TextInputTableViewCell)
    func textFieldDidEndEditing(_ textField: UITextField, for cell: TextInputTableViewCell)
}

public protocol TextInputFieldCell: FormFieldCell {
    var textInputCellDelegate: TextInputTableViewDelegate? { get set }
    
    func setup(for field: StringField)
    func setup(for field: NumberField)
}

open class TextInputTableViewCell: InputTableViewCell, TextInputFieldCell {
    private(set) var inputField: TextField?
    weak public var textInputCellDelegate: TextInputTableViewDelegate?
    
    public var cell: FormFieldTableViewCell {
        return self
    }
    
    public override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        textField.delegate = self
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open func setup(for field: TextField) {
        self.inputField = field
        label.text = field.label
        textField.text = field.value
        textField.isEnabled = field.isEnabled
        
        if field.isRequired {
            textField.placeholder = "Label.Required".localized().uppercased()
        } else {
            textField.placeholder = "Label.Optional".localized().uppercased()
        }
        
        textField.attributedPlaceholder = NSAttributedString(string: textField.placeholder!, attributes: [NSAttributedStringKey.foregroundColor: Style.shared.placeholder.color])
    }
    
    open func setup(for field: StringField) {
        textField.isSecureTextEntry = field.type == .password
        textField.keyboardType = .alphabet
        self.setup(for: field as TextField)
    }
    
    open func setup(for field: NumberField) {
        switch field.type {
        case .integer: textField.keyboardType = .numberPad
        case .decimal: textField.keyboardType = .decimalPad
        }
        
        self.setup(for: field as TextField)
    }
}

extension TextInputTableViewCell: UITextFieldDelegate {
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        switch textField.keyboardType {
        case .numberPad:
            return string.isEmpty || Int(string) != nil
        case .decimalPad:
            return string.isEmpty || Double(string) != nil || (string == "." && textField.text?.index(of: ".") == nil)
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
        
        if let field = inputField, let indexPath = indexPath {
            delegate?.valueChanged(for: field, at: indexPath)
        }
    }
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return textInputCellDelegate?.textFieldShouldReturn(for: self) ?? true
    }
    
    public func textFieldShouldClear(_ textField: UITextField) -> Bool {
        return true
    }
}
