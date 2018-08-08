//
//  TextAreaTableViewCell.swift
//  SafetyBoot
//
//  Created by Jacob Sikorski on 2017-03-23.
//  Copyright © 2017 Tamarai. All rights reserved.
//

import Foundation
import UIKit

class TextAreaTableViewCell: FormFieldTableViewCell {
    private(set) var label: UILabel
    private(set) var valueLabel: UILabel
    private(set) var field: StringField?
    
    public override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        label = UILabel()
        valueLabel = UILabel()
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        label.textColor = Style.shared.label.color
        valueLabel.textColor = Style.shared.value.color
        
        contentView.addSubview(label)
        contentView.addSubview(valueLabel)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        valueLabel.translatesAutoresizingMaskIntoConstraints = false
        
        label.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 15).isActive = true
        label.leadingAnchor.constraint(equalTo: readableContentGuide.leadingAnchor, constant: 0).isActive = true
        label.trailingAnchor.constraint(equalTo: readableContentGuide.trailingAnchor, constant: 0).isActive = true
        
        valueLabel.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 0).isActive = true
        valueLabel.leadingAnchor.constraint(equalTo: readableContentGuide.leadingAnchor, constant: 0).isActive = true
        valueLabel.trailingAnchor.constraint(equalTo: readableContentGuide.trailingAnchor, constant: 0).isActive = true
        
        contentView.bottomAnchor.constraint(greaterThanOrEqualTo: valueLabel.bottomAnchor, constant: 8).isActive = true
        
        label.setContentHuggingPriority(UILayoutPriority.defaultLow, for: .vertical)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup(for field: StringField) {
        self.field = field
        label.text = field.label
        if let value = field.value, !value.isEmpty {
            valueLabel.textColor = UIColor.darkGray
            valueLabel.text = value
        } else {
            valueLabel.textColor = UIColor.lightGray
            
            if field.isRequired {
                valueLabel.text = "Label.Required".localized().uppercased()
            } else {
                valueLabel.text = "Label.Optional".localized().uppercased()
            }
        }
    }
}
