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
        return signatureView
    }()
    
    weak var delegate: EditSignatureViewControllerDelegate?
    var signatureField: SignatureField
    
    init(signatureField: SignatureField) {
        self.signatureField = signatureField
        super.init(nibName: nil, bundle: nil)
        setupLayout()
        view.backgroundColor = Style.current.secondaryBackgroundColor
        signatureView.backgroundColor = Style.current.backgroundColor
        
        let cancelButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.cancel, target: self, action: #selector(tappedCancelButton))
        self.navigationItem.leftBarButtonItem = cancelButton
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.done, target: self, action: #selector(tappedDoneButton))
        
        let clearButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.trash, target: self, action: #selector(tappedClearButton))
        
        self.navigationItem.rightBarButtonItems = [doneButton, clearButton]
        title = "Title.Signature".localized()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure(with: Style.current)
    }
    
    private func setupLayout() {
        view.addSubview(signatureView)
        
        signatureView.translatesAutoresizingMaskIntoConstraints = false
        signatureView.heightAnchor.constraint(equalTo: signatureView.widthAnchor, multiplier: 1.0/3.0).isActive = true
        signatureView.leadingAnchor.constraint(equalTo: view.readableContentGuide.leadingAnchor).isActive = true
        signatureView.trailingAnchor.constraint(equalTo: view.readableContentGuide.trailingAnchor).isActive = true
        signatureView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    
    @objc private func tappedDoneButton() {
        guard signatureField.image != nil else {
            setSignature()
            return
        }
        
        // Only show alert if we're changing the signature.
        let alertController = UIAlertController(title: "Title.UpdateSignature?".localized(), message: "Message.SignatureUpdateConfirmation".localized(), preferredStyle: UIAlertController.Style.actionSheet)
        
        alertController.addAction(UIAlertAction(title: "Button.Update".localized(), style: UIAlertAction.Style.destructive, handler: { action in
            self.setSignature()
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
    
    private func setSignature() {
        let image = signatureView.croppedSignature?.cgImage
        signatureField.image = image
        delegate?.editSignatureViewController(self, didUpdateField: self.signatureField)
    }
}
