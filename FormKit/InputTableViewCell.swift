//
//  InputTableViewCell.swift
//  FormKit
//
//  Created by Jacob Sikorski on 2017-10-30.
//  Copyright © 2017 Jacob Sikorski. All rights reserved.
//

import Foundation

open class InputTableViewCell: FormFieldTableViewCell {
    lazy var label: UILabel = {
        let label = UILabel()
        label.configure(with: Style.current.label)
        label.numberOfLines = 0
        return label
    }()
    
    lazy var textField: UITextField = {
        let textField = UITextField()
        textField.configure(with: Style.current.value)
        return textField
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayout()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
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
        label.setContentHuggingPriority(.defaultLow, for: .vertical)
    }
    
    func configure(with field: InputField) {
        label.text = field.label
        textField.isEnabled = field.isEnabled
        textField.text = field.value
        
        if field.isRequired {
            textField.placeholder = "Label.Required".localized().uppercased()
        } else {
            textField.placeholder = "Label.Optional".localized().uppercased()
        }
        
        textField.attributedPlaceholder = NSAttributedString(string: textField.placeholder!, attributes: [NSAttributedStringKey.foregroundColor: Style.current.placeholder.color])
    }
}
