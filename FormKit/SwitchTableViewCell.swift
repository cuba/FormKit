//
//  SwitchTableViewCell.swift
//  retail
//
//  Created by Jacob Sikorski on 2016-07-15.
//  Copyright © 2016 Jacob Sikorski. All rights reserved.
//

import UIKit

public protocol BoolFieldCell: FormFieldCell {
    func configure(with field: BoolField)
}

class SwitchTableViewCell: FormFieldTableViewCell, BoolFieldCell {
    
    lazy var label: UILabel = {
        let label = UILabel()
        label.configure(with: Style.current.label)
        label.numberOfLines = 0
        return label
    }()
    
    var onSwitch: UISwitch = {
        let onSwitch = UISwitch()
        onSwitch.addTarget(self, action: #selector(switchValueChanged), for: .valueChanged)
        return onSwitch
    }()
    
    var boolField: BoolField?
    
    public override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayout()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc private func switchValueChanged(_ sender: UISwitch) {
        boolField?.isChecked = sender.isOn
        
        if let field = self.boolField, let indexPath = self.indexPath {
            delegate?.valueChanged(for: field, at: indexPath)
        }
    }
    
    func configure(with field: BoolField) {
        self.boolField = field
        label.text = field.label
        onSwitch.isOn = field.isChecked ?? false
        onSwitch.isEnabled = field.isEnabled
    }
    
    private func setupLayout() {
        contentView.addSubview(label)
        accessoryView = onSwitch
        
        label.translatesAutoresizingMaskIntoConstraints = false

        label.leadingAnchor.constraint(equalTo: contentView.readableContentGuide.leadingAnchor).isActive = true
        label.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 15).isActive = true
        label.trailingAnchor.constraint(equalTo: contentView.readableContentGuide.trailingAnchor).isActive = true
        contentView.bottomAnchor.constraint(equalTo: label.bottomAnchor, constant: 15).isActive = true
    }
}
