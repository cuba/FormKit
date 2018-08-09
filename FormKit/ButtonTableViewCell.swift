//
//  ButtonTableViewCell.swift
//  retail
//
//  Created by Jacob Sikorski on 2016-06-09.
//  Copyright © 2016 Jacob Sikorski. All rights reserved.
//

import UIKit

protocol ButtonTableViewCellDelegate {
    func buttonTableViewCellButtonClicked(_ cell: ButtonTableViewCell)
}

class ButtonTableViewCell: FormFieldTableViewCell {
    lazy var button: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(tappedButton), for: .touchUpInside)
        return button
    }()
    
    var buttonDelegate: ButtonTableViewCellDelegate?
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = UITableViewCellSelectionStyle.none
        setupLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func tappedButton(_ button: UIButton) {
        buttonDelegate?.buttonTableViewCellButtonClicked(self)
    }
    
    private func setupLayout() {
        contentView.addSubview(button)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 15).isActive = true
        button.leadingAnchor.constraint(equalTo: contentView.readableContentGuide.leadingAnchor, constant: 0).isActive = true
        button.trailingAnchor.constraint(equalTo: contentView.readableContentGuide.trailingAnchor, constant: 0).isActive = true
        contentView.bottomAnchor.constraint(greaterThanOrEqualTo: button.bottomAnchor, constant: 8).isActive = true
        
        button.setContentHuggingPriority(.defaultLow, for: .vertical)
    }
}
