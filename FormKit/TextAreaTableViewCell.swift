//
//  TextAreaTableViewCell.swift
//  SafetyBoot
//
//  Created by Jacob Sikorski on 2017-03-23.
//  Copyright © 2017 Tamarai. All rights reserved.
//

import Foundation
import UIKit

public protocol TextAreaFieldCell: FormFieldCell {
    func configure(with field: TextAreaField)
}

class TextAreaTableViewCell: LabeledFieldTableViewCell, TextAreaFieldCell {
    
    lazy var valueLabel: UILabel = {
        let valueLabel = UILabel()
        valueLabel.configure(with: Style.current.value)
        valueLabel.numberOfLines = 0
        return valueLabel
    }()
    
    private(set) var field: TextField?
    
    public override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with field: MultipleSelectField){
        configure(with: field as TextField)
    }
    
    func configure(with field: TextAreaField) {
        configure(with: field as TextField)
    }
    
    private func configure(with field: TextField) {
        self.field = field
        label.text = field.label
        accessoryType = .disclosureIndicator
        
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
