//
//  SingleSelectTableViewCell.swift
//  retail
//
//  Created by Jacob Sikorski on 2016-06-11.
//  Copyright © 2016 Jacob Sikorski. All rights reserved.
//

import UIKit

public protocol SingleSelectFieldCell: FormFieldCell {
    func configure(with field: SingleSelectField)
}

class SingleSelectTableViewCell: FormFieldTableViewCell, SingleSelectFieldCell {
    var label: UILabel!
    var subtitleLabel: UILabel!
    private(set) var field: FormField?
    
    var tableViewCell: FormFieldTableViewCell {
        return self
    }
    
    public override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        label = UILabel()
        label.textColor = Style.shared.label.color
        subtitleLabel = UILabel()
        accessoryType = .disclosureIndicator
        
        contentView.addSubview(label)
        contentView.addSubview(subtitleLabel)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        label.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 15).isActive = true
        label.leadingAnchor.constraint(equalTo: contentView.readableContentGuide.leadingAnchor, constant: 0).isActive = true
        
        subtitleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 15).isActive = true
        subtitleLabel.leadingAnchor.constraint(greaterThanOrEqualTo: label.trailingAnchor, constant: 15).isActive = true
        subtitleLabel.trailingAnchor.constraint(equalTo: contentView.readableContentGuide.trailingAnchor, constant: 0).isActive = true
        
        contentView.bottomAnchor.constraint(greaterThanOrEqualTo: label.bottomAnchor, constant: 15).isActive = true
        contentView.bottomAnchor.constraint(greaterThanOrEqualTo: subtitleLabel.bottomAnchor, constant: 15).isActive = true
        
        label.setContentCompressionResistancePriority(UILayoutPriority(rawValue: 751), for: .horizontal)
        label.setContentHuggingPriority(UILayoutPriority(rawValue: 751), for: .vertical)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with field: SingleSelectField) {
        self.field = field
        label.text = field.label
        
        if let value = field.value {
            subtitleLabel.textColor = Style.shared.value.color
            subtitleLabel.text = value
        } else {
            subtitleLabel.textColor = Style.shared.placeholder.color
            
            if field.isRequired {
                subtitleLabel.text = "Label.Required".localized().uppercased()
            } else {
                subtitleLabel.text = "Label.Optional".localized().uppercased()
            }
        }
    }
}
