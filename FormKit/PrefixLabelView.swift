//
//  PrefixLabelView.swift
//  FormKit
//
//  Created by Jacob Sikorski on 2018-08-08.
//  Copyright © 2018 Jacob Sikorski. All rights reserved.
//

import UIKit

class PrefixLableView: UIView {
    
    lazy var prefix: UILabel = {
        let label = UILabel()
        label.configure(with: Style.current.placeholder)
        label.numberOfLines = 1
        return label
    }()
    
    lazy var label: UILabel = {
        let label = UILabel()
        label.configure(with: Style.current.label)
        label.numberOfLines = 0
        return label
    }()
    
    var prefixToLabelConstraint: NSLayoutConstraint?
    var viewToLabelConstraint: NSLayoutConstraint?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViews()
    }
    
    private func setupViews() {
        addSubview(label)
        addSubview(prefix)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        prefix.translatesAutoresizingMaskIntoConstraints = false
        
        prefix.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        prefix.topAnchor.constraint(equalTo: topAnchor).isActive = true
        
        label.topAnchor.constraint(equalTo: topAnchor).isActive = true
        label.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        bottomAnchor.constraint(equalTo: label.bottomAnchor).isActive = true
        
        prefixToLabelConstraint = label.leadingAnchor.constraint(equalTo: prefix.trailingAnchor, constant: 8)
        viewToLabelConstraint = label.leadingAnchor.constraint(equalTo: leadingAnchor)
        
        prefix.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        prefix.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        label.setContentHuggingPriority(.defaultLow, for: .vertical)
        
        hidePrefix()
    }
    
    func hidePrefix() {
        viewToLabelConstraint?.isActive = true
        prefixToLabelConstraint?.isActive = false
        prefix.isHidden = true
    }
    
    func showPrefix() {
        viewToLabelConstraint?.isActive = false
        prefixToLabelConstraint?.isActive = true
        prefix.isHidden = false
    }
}
