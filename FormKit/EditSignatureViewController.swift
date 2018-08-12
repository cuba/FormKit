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
    func editSignatureViewControllerDidCancel(_ controller: EditSignatureViewController)
}

class EditSignatureViewController: UIViewController {
    lazy var signatureView: SignatureView = {
        let signatureView = SignatureView()
        signatureView.backgroundColor = UIColor.white
        return signatureView
    }()
    
    weak var delegate: EditSignatureViewControllerDelegate?
    var signatureField: SignatureField
    
    init(signatureField: SignatureField) {
        self.signatureField = signatureField
        super.init(nibName: nil, bundle: nil)
        setupLayout()
        
        view.backgroundColor = Style.current.page.background.color
        
        let cancelButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.cancel, target: self, action: #selector(tappedCancelButton))
        self.navigationItem.leftBarButtonItem = cancelButton
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done, target: self, action: #selector(tappedDoneButton))
        
        let clearButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.trash, target: self, action: #selector(tappedClearButton))
        
        self.navigationItem.rightBarButtonItems = [doneButton, clearButton]
        title = "Title.Signature".localized()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        view.addSubview(signatureView)
        
        signatureView.translatesAutoresizingMaskIntoConstraints = false
        
        signatureView.topAnchor.constraint(greaterThanOrEqualTo: view.layoutMarginsGuide.topAnchor, constant: 15).isActive = true
        signatureView.bottomAnchor.constraint(greaterThanOrEqualTo: view.layoutMarginsGuide.bottomAnchor, constant: -15).isActive = true
        signatureView.heightAnchor.constraint(equalTo: signatureView.widthAnchor, multiplier: 1.0/3.0).isActive = true
        signatureView.leadingAnchor.constraint(equalTo: view.readableContentGuide.leadingAnchor).isActive = true
        signatureView.trailingAnchor.constraint(equalTo: view.readableContentGuide.trailingAnchor).isActive = true
        signatureView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    
    @objc private func tappedDoneButton() {
        let alertController = UIAlertController(title: "Button.Save".localized(), message: "Message.SignatureUpdateConfirmation".localized(), preferredStyle: UIAlertControllerStyle.actionSheet)
        
        alertController.addAction(UIAlertAction(title: "Button.Save".localized(), style: UIAlertActionStyle.destructive, handler: { action in
            let image = self.signatureView.croppedSignature?.cgImage
            self.signatureField.image = image
            self.delegate?.editSignatureViewController(self, didUpdateField: self.signatureField)
        }))
        
        alertController.addAction(UIAlertAction(title: "Button.Cancel".localized(), style: .cancel, handler: nil))
        alertController.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItems?.first
    
        present(alertController, animated: true, completion: nil)
    }
    
    @objc private func tappedCancelButton() {
        delegate?.editSignatureViewControllerDidCancel(self)
    }
    
    @objc private func tappedClearButton() {
        signatureView.clear()
    }
}
