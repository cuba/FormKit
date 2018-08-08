//
//  InputTableViewCell.swift
//  FormKit
//
//  Created by Jacob Sikorski on 2017-10-30.
//  Copyright © 2017 Jacob Sikorski. All rights reserved.
//

import Foundation

open class InputTableViewCell: FormFieldTableViewCell {
    var label: UILabel!
    var textField: UITextField!
    
    public override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        label = UILabel()
        label.textColor = Style.shared.label.color
        
        textField = UITextField()
        textField.textColor = Style.shared.value.color
        
        contentView.addSubview(label)
        contentView.addSubview(textField)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        label.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 15).isActive = true
        label.leadingAnchor.constraint(equalTo: contentView.readableContentGuide.leadingAnchor, constant: 0).isActive = true
        label.trailingAnchor.constraint(equalTo: contentView.readableContentGuide.trailingAnchor, constant: 0).isActive = true
        
        textField.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 6).isActive = true
        textField.leadingAnchor.constraint(equalTo: contentView.readableContentGuide.leadingAnchor, constant: 0).isActive = true
        textField.trailingAnchor.constraint(equalTo: contentView.readableContentGuide.trailingAnchor, constant: 0).isActive = true
        
        contentView.bottomAnchor.constraint(greaterThanOrEqualTo: textField.bottomAnchor, constant: 8).isActive = true
        
        label.setContentHuggingPriority(UILayoutPriority.defaultLow, for: .vertical)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
