//
//  SingleSelectTableViewCell.swift
//  retail
//
//  Created by Jacob Sikorski on 2016-06-11.
//  Copyright © 2016 Jacob Sikorski. All rights reserved.
//

import UIKit

public protocol SingleSelectFieldCellProvider: FormFieldCellProvider {
    func configure(with field: SingleSelectField)
}

open class SingleSelectTableViewCell: FormFieldTableViewCell, SingleSelectFieldCellProvider {
    
    public lazy var label: UILabel = {
        let label = UILabel()
        label.configure(with: Style.current.label)
        label.numberOfLines = 0
        return label
    }()
    
    public lazy var subtitleLabel: UILabel = {
        let subtitleLabel = UILabel()
        subtitleLabel.configure(with: Style.current.value)
        subtitleLabel.textAlignment = .right
        return subtitleLabel
    }()
    
    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayout()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open func configure(with field: SingleSelectField) {
        label.text = field.label
        
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
        
        if field.isEnabled {
            accessoryType = .disclosureIndicator
        } else {
            accessoryType = .none
        }
    }
    
    private func setupLayout() {
        contentView.addSubview(label)
        contentView.addSubview(subtitleLabel)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        label.topAnchor.constraint(equalTo: contentView.layoutMarginsGuide.topAnchor, constant: Style.current.cell.topMargin).isActive = true
        label.leadingAnchor.constraint(equalTo: contentView.readableContentGuide.leadingAnchor).isActive = true
        
        subtitleLabel.leadingAnchor.constraint(greaterThanOrEqualTo: label.trailingAnchor).isActive = true
        subtitleLabel.trailingAnchor.constraint(equalTo: contentView.readableContentGuide.trailingAnchor, constant: 0).isActive = true
        subtitleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        
        contentView.layoutMarginsGuide.bottomAnchor.constraint(greaterThanOrEqualTo: label.bottomAnchor, constant: Style.current.cell.bottomMargin).isActive = true
        
        label.setContentHuggingPriority(.defaultHigh, for: .vertical)
        label.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        subtitleLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
    }
}
