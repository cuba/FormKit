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

class ButtonTableViewCell: UITableViewCell {
    private(set) var button: UIButton
    var delegate:ButtonTableViewCellDelegate?
    
    required init?(coder aDecoder: NSCoder) {
        button = UIButton()
        super.init(coder: aDecoder)
        self.selectionStyle = UITableViewCellSelectionStyle.none
        
        button.setTitleColor(Style.shared.primaryButton.text.color, for: .normal)
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        
        contentView.addSubview(button)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 15).isActive = true
        button.leadingAnchor.constraint(equalTo: readableContentGuide.leadingAnchor, constant: 0).isActive = true
        button.trailingAnchor.constraint(equalTo: readableContentGuide.trailingAnchor, constant: 0).isActive = true
        contentView.bottomAnchor.constraint(greaterThanOrEqualTo: button.bottomAnchor, constant: 8).isActive = true
        
        button.setContentHuggingPriority(UILayoutPriority.defaultLow, for: .vertical)
    }
    
    @objc func buttonTapped(_ button: UIButton) {
        delegate?.buttonTableViewCellButtonClicked(self)
    }
}
