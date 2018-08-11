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
    func configure(with field: InputField)
    func configure(with field: MultipleSelectField)
}

open class TextAreaTableViewCell: FormFieldTableViewCell, TextAreaFieldCellProvider {
    
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
    
    public private(set) var field: EditableField?
    
    public override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayout()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open func configure(with field: MultipleSelectField) {
        configure(with: field as EditableField)
        
        if let value = field.value, !value.isEmpty {
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
    }
    
    open func configure(with field: InputField) {
        configure(with: field as EditableField)
        
        if let value = field.value, !value.isEmpty {
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
    }
    
    private func configure(with field: EditableField) {
        self.field = field
        label.text = field.label
        accessoryType = .disclosureIndicator
    }
    
    private func setupLayout() {
        contentView.addSubview(label)
        contentView.addSubview(valueLabel)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        valueLabel.translatesAutoresizingMaskIntoConstraints = false
        
        label.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 15).isActive = true
        label.leadingAnchor.constraint(equalTo: contentView.readableContentGuide.leadingAnchor).isActive = true
        label.trailingAnchor.constraint(equalTo: contentView.readableContentGuide.trailingAnchor, constant: 0).isActive = true
        
        valueLabel.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 6).isActive = true
        valueLabel.leadingAnchor.constraint(equalTo: contentView.readableContentGuide.leadingAnchor, constant: 0).isActive = true
        valueLabel.trailingAnchor.constraint(equalTo: contentView.readableContentGuide.trailingAnchor, constant: 0).isActive = true
        
        contentView.bottomAnchor.constraint(greaterThanOrEqualTo: valueLabel.bottomAnchor, constant: 8).isActive = true
        label.setContentHuggingPriority(.defaultLow, for: .vertical)
    }
}
