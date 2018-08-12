//
//  SignatureTableViewCell.swift
//  FormKit
//
//  Created by Jacob Sikorski on 2018-08-08.
//  Copyright © 2018 Jacob Sikorski. All rights reserved.
//

import Foundation

public protocol SignatureFieldCellProvider: FormFieldCellProvider {
    func configure(with field: SignatureField)
}

class SignatureTableViewCell: FormFieldTableViewCell, SignatureFieldCellProvider {
    lazy var signatureImageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    private lazy var label: UILabel = {
        let textView = UILabel()
        textView.configure(with: Style.current.placeholder)
        textView.textAlignment = .center
        return textView
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with field: SignatureField) {
        if let image = field.image {
            signatureImageView.image = UIImage(cgImage: image)
            label.text = nil
            label.isHidden = true
        } else {
            label.text = field.label
            label.isHidden = false
        }
        
        if field.isEnabled {
            accessoryType = .disclosureIndicator
        } else {
            accessoryType = .none
        }
        
        // TODO: @JS Handle isRequired
    }
    
    private func setupLayout() {
        contentView.addSubview(signatureImageView)
        contentView.addSubview(label)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        signatureImageView.translatesAutoresizingMaskIntoConstraints = false
        
        signatureImageView.leadingAnchor.constraint(equalTo: contentView.readableContentGuide.leadingAnchor).isActive = true
        signatureImageView.trailingAnchor.constraint(equalTo: contentView.readableContentGuide.trailingAnchor).isActive = true
        signatureImageView.topAnchor.constraint(greaterThanOrEqualTo: contentView.topAnchor, constant: 15).isActive = true
        contentView.bottomAnchor.constraint(greaterThanOrEqualTo: signatureImageView.bottomAnchor, constant: 15).isActive = true
        
        label.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 15).isActive = true
        label.leadingAnchor.constraint(equalTo: signatureImageView.leadingAnchor).isActive = true
        label.trailingAnchor.constraint(equalTo: signatureImageView.trailingAnchor).isActive = true
        contentView.bottomAnchor.constraint(greaterThanOrEqualTo: label.bottomAnchor, constant: 15).isActive = true
        
        label.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
    }
}
