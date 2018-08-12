//
//  EditSignatureViewController.swift
//  FormKit
//
//  Created by Jacob Sikorski on 2018-08-11.
//  Copyright © 2018 Jacob Sikorski. All rights reserved.
//

import UIKit

protocol EditSignatureViewControllerDelegate: class {
    func editSignatureViewController(_ controller: EditSignatureViewController, didUpdateField signatureField: SignatureField)
}

class EditSignatureViewController: UIViewController {
    weak var delegate: EditSignatureViewControllerDelegate?
    var signatureField: SignatureField
    
    init(signatureField: SignatureField) {
        self.signatureField = signatureField
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
