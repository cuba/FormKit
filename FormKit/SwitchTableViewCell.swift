//
//  SwitchTableViewCell.swift
//  retail
//
//  Created by Jacob Sikorski on 2016-07-15.
//  Copyright © 2016 Jacob Sikorski. All rights reserved.
//

import UIKit

public protocol BoolFieldCell: FormFieldCell {
    func setup(for field: BoolField)
}

class SwitchTableViewCell: FormFieldTableViewCell, BoolFieldCell {
    private(set) var label: UILabel!
    private(set) var onSwitch: UISwitch!
    private(set) var prefixLabel: UILabel!
    private(set) var boolField: BoolField?
    
    public var cell: FormFieldTableViewCell {
        return self
    }
    
    public override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        label = UILabel()
        onSwitch = UISwitch()
        
        label.textColor = Style.shared.label.color
        onSwitch.addTarget(self, action: #selector(switchValueChanged), for: .valueChanged)
        
        contentView.addSubview(label)
        contentView.addSubview(onSwitch)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        onSwitch.translatesAutoresizingMaskIntoConstraints = false
        
        label.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 15).isActive = true
        label.leadingAnchor.constraint(equalTo: readableContentGuide.leadingAnchor, constant: 0).isActive = true
        contentView.bottomAnchor.constraint(equalTo: label.bottomAnchor, constant: 15).isActive = true
        
        onSwitch.centerYAnchor.constraint(equalTo: contentView.centerYAnchor, constant: 0).isActive = true
        onSwitch.leadingAnchor.constraint(equalTo: label.trailingAnchor, constant: 0).isActive = true
        onSwitch.trailingAnchor.constraint(equalTo: readableContentGuide.trailingAnchor, constant: 0).isActive = true
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    @objc private func switchValueChanged(_ sender: UISwitch) {
        boolField?.value = sender.isOn
        
        if let field = self.boolField, let indexPath = self.indexPath {
            delegate?.valueChanged(for: field, at: indexPath)
        }
    }
    
    func setup(for field: BoolField) {
        self.boolField = field
        label.text = field.label
        //prefixLabel.text = field.prefix
        onSwitch.isOn = field.value ?? false
        onSwitch.isEnabled = field.isEnabled
    }
}
