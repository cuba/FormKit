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

class SingleSelectTableViewCell: LabeledFieldTableViewCell, SingleSelectFieldCell {
    
    lazy var subtitleLabel: UILabel = {
        let subtitleLabel = UILabel()
        subtitleLabel.configure(with: Style.current.value)
        subtitleLabel.textAlignment = .right
        return subtitleLabel
    }()
    
    private(set) var field: FormField?
    
    public override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with field: SingleSelectField) {
        self.field = field
        label.text = field.label
        accessoryType = .disclosureIndicator
        
        if let value = field.value {
            subtitleLabel.configure(with: Style.current.value)
            subtitleLabel.text = value
        } else {
            subtitleLabel.configure(with: Style.current.placeholder)
            
            if field.isRequired {
                subtitleLabel.text = "Label.Required".localized().uppercased()
            } else {
                subtitleLabel.text = "Label.Optional".localized().uppercased()
            }
        }
    }
    
    private func setupLayout() {
        contentView.addSubview(label)
        contentView.addSubview(subtitleLabel)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        label.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 15).isActive = true
        label.leadingAnchor.constraint(equalTo: contentView.readableContentGuide.leadingAnchor, constant: 0).isActive = true
        
        subtitleLabel.leadingAnchor.constraint(greaterThanOrEqualTo: label.trailingAnchor, constant: 15).isActive = true
        subtitleLabel.trailingAnchor.constraint(equalTo: contentView.readableContentGuide.trailingAnchor, constant: 0).isActive = true
        subtitleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        
        contentView.bottomAnchor.constraint(greaterThanOrEqualTo: label.bottomAnchor, constant: 15).isActive = true
        
        label.setContentHuggingPriority(.defaultHigh, for: .vertical)
    }
}
