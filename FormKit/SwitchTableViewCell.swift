//
//  SwitchTableViewCell.swift
//  retail
//
//  Created by Jacob Sikorski on 2016-07-15.
//  Copyright © 2016 Jacob Sikorski. All rights reserved.
//

import UIKit

protocol SwitchTableViewCellDelegate: class {
    func switchTableViewCell(_ cell: SwitchTableViewCell, didUpdateField field: BoolField)
}

public protocol BoolFieldCell: FormFieldCellProvider {
    func configure(with field: BoolField)
}

open class SwitchTableViewCell: FormFieldTableViewCell, BoolFieldCell {
    weak var delegate: SwitchTableViewCellDelegate?
    
    public lazy var label: UILabel = {
        let label = UILabel()
        label.configure(with: Style.current.label)
        label.numberOfLines = 0
        return label
    }()
    
    public var onSwitch: UISwitch = {
        let onSwitch = UISwitch()
        onSwitch.addTarget(self, action: #selector(switchValueChanged), for: .valueChanged)
        return onSwitch
    }()
    
    public private(set) var field: BoolField?
    
    public override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayout()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open func configure(with field: BoolField) {
        self.field = field
        label.text = field.label
        onSwitch.isOn = field.isChecked ?? false
        onSwitch.isEnabled = field.isEnabled
    }

    @objc private func switchValueChanged(_ sender: UISwitch) {
        field?.isChecked = sender.isOn
        guard let field = self.field else { return }
        delegate?.switchTableViewCell(self, didUpdateField: field)
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
