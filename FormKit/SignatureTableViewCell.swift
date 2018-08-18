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
    
    lazy var label: UILabel = {
        let textView = UILabel()
        textView.configure(with: Style.current.placeholder)
        textView.textAlignment = .center
        return textView
    }()
    
    lazy var signatureImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var signatureImageViewBottomMargin: NSLayoutConstraint = {
        return signatureImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
    }()
    
    private lazy var labelBottomMargin: NSLayoutConstraint = {
        return label.bottomAnchor.constraint(equalTo: contentView.layoutMarginsGuide.bottomAnchor, constant: -Style.current.cell.bottomMargin)
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
            let uiImage = UIImage(cgImage: image)
            signatureImageView.image = uiImage
            label.text = nil
            label.isHidden = true
            signatureImageView.isHidden = false
            signatureImageViewBottomMargin.isActive = true
            labelBottomMargin.isActive = false
        } else {
            label.text = field.label
            label.isHidden = false
            signatureImageView.isHidden = true
            signatureImageViewBottomMargin.isActive = false
            labelBottomMargin.isActive = true
        }
        
        if field.isEnabled {
            accessoryType = .disclosureIndicator
        } else {
            accessoryType = .none
        }
    }
    
    private func setupLayout() {
        contentView.addSubview(signatureImageView)
        contentView.addSubview(label)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        signatureImageView.translatesAutoresizingMaskIntoConstraints = false
        
        signatureImageView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        signatureImageView.leadingAnchor.constraint(equalTo: contentView.readableContentGuide.leadingAnchor).isActive = true
        signatureImageView.trailingAnchor.constraint(equalTo: contentView.readableContentGuide.trailingAnchor).isActive = true
        signatureImageView.heightAnchor.constraint(lessThanOrEqualTo: signatureImageView.widthAnchor, multiplier: 1.0/3.0).isActive = true
        
        label.topAnchor.constraint(equalTo: contentView.layoutMarginsGuide.topAnchor, constant: Style.current.cell.topMargin).isActive = true
        label.leadingAnchor.constraint(equalTo: contentView.readableContentGuide.leadingAnchor).isActive = true
        label.trailingAnchor.constraint(equalTo: contentView.readableContentGuide.trailingAnchor).isActive = true
    
        signatureImageView.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        signatureImageView.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
    }
}
