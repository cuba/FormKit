//
//  TextAreaTableViewCell.swift
//  SafetyBoot
//
//  Created by Jacob Sikorski on 2017-03-23.
//  Copyright © 2017 Tamarai. All rights reserved.
//

import Foundation
import UIKit

public protocol TextAreaFieldCellProvider: FormFieldCellProvider {
    func configure(with field: TextAreaField)
}

public protocol MultipleSelectFieldCellProvider: FormFieldCellProvider {
    func configure(with field: MultipleSelectField)
}

public protocol InputFieldCellProvider: FormFieldCellProvider {
    func configure(with field: TextAreaField)
}

open class TextAreaTableViewCell: FormFieldTableViewCell, TextAreaFieldCellProvider, MultipleSelectFieldCellProvider, InputFieldCellProvider {
    
    public lazy var label: UILabel = {
        let label = UILabel()
        label.configure(with: Style.current.label)
        label.numberOfLines = 0
        return label
    }()
    
    public lazy var valueLabel: UILabel = {
        let valueLabel = UILabel()
        valueLabel.configure(with: Style.current.value)
        valueLabel.numberOfLines = 0
        return valueLabel
    }()
    
    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayout()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open func configure(with field: MultipleSelectField) {
        configure(with: field as EditableField, value: field.value)
    }
    
    open func configure(with field: TextAreaField) {
        configure(with: field as EditableField, value: field.value)
    }
    
    open func configure(with field: InputField) {
        configure(with: field as EditableField, value: field.value)
    }
    
    open func configure(with field: StandardField) {
        label.text = field.title
        valueLabel.text = field.subtitle
        valueLabel.configure(with: Style.current.value)
        
        if let accessoryType = field.accessoryType {
            self.accessoryType = accessoryType
        } else {
            accessoryType = .none
        }
    }
    
    open func configure(with field: EditableField, value: String?) {
        label.text = field.label
        
        if let value = value, !value.isEmpty {
            valueLabel.configure(with: Style.current.value)
            valueLabel.text = value.trim()
        } else {
            valueLabel.configure(with: Style.current.placeholder)
            
            if field.isRequired {
                valueLabel.text = "Label.Required".localized().uppercased()
            } else {
                valueLabel.text = "Label.Optional".localized().uppercased()
            }
        }
        
        if field.isEnabled {
            accessoryType = .disclosureIndicator
        } else {
            accessoryType = .none
        }
    }
    
    private func setupLayout() {
        contentView.addSubview(label)
        contentView.addSubview(valueLabel)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        valueLabel.translatesAutoresizingMaskIntoConstraints = false
        
        label.topAnchor.constraint(equalTo: contentView.layoutMarginsGuide.topAnchor, constant: Style.current.cell.topMargin).isActive = true
        label.leadingAnchor.constraint(equalTo: contentView.readableContentGuide.leadingAnchor).isActive = true
        label.trailingAnchor.constraint(equalTo: contentView.readableContentGuide.trailingAnchor).isActive = true
        
        valueLabel.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 6).isActive = true
        valueLabel.leadingAnchor.constraint(equalTo: contentView.readableContentGuide.leadingAnchor, constant: 0).isActive = true
        valueLabel.trailingAnchor.constraint(equalTo: contentView.readableContentGuide.trailingAnchor, constant: 0).isActive = true
        
        contentView.layoutMarginsGuide.bottomAnchor.constraint(greaterThanOrEqualTo: valueLabel.bottomAnchor, constant: Style.current.cell.bottomMargin).isActive = true
        label.setContentHuggingPriority(.defaultLow, for: .vertical)
    }
}
