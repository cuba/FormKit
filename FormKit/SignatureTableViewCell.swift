//
//  SignatureTableViewCell.swift
//  FormKit
//
//  Created by Jacob Sikorski on 2018-08-08.
//  Copyright © 2018 Jacob Sikorski. All rights reserved.
//

import Foundation

protocol SignatureFieldCell {
    
}

protocol SignatureTableViewCellDelegate {
    
}

class SignatureTableViewCell: FormFieldTableViewCell, SignatureFieldCell {
    lazy var signatureImageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    private lazy var placeholderText: UILabel = {
        let textView = UILabel()
        textView.configure(with: Style.current.placeholder)
        return textView
    }()
    
    var signatureDelegate: SignatureTableViewCellDelegate?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
