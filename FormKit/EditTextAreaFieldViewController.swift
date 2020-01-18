//
//  EditTextAreaFieldViewController.swift
//  FormKit
//
//  Created by Jacob Sikorski on 2018-08-08.
//  Copyright © 2018 Jacob Sikorski. All rights reserved.
//

import Foundation

import UIKit

protocol EditTextAreaFieldViewControllerDelegate {
    func textViewController(_ textViewController: EditTextAreaFieldViewController, didUpdateField textAreaField: TextAreaField)
}

class EditTextAreaFieldViewController: UIViewController {
    lazy var textView: UITextView = {
        let textView = UITextView(frame: CGRect.zero)
        textView.text = field.value
        textView.delegate = self
        textView.configure(with: Style.current.textArea)
        return textView
    }()
    
    var field: TextAreaField
    var delegate: EditTextAreaFieldViewControllerDelegate?
    
    init(field: TextAreaField) {
        self.field = field
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure(with: Style.current.page)
        setupLayout()
        title = field.label
        textView.autocapitalizationType = field.autocapitalizationType
        textView.autocorrectionType = field.autocorrectionType
        textView.keyboardType = field.keyboardType
        
        if let textContentType = field.textContentType {
            textView.textContentType = textContentType
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name:UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name:UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.textView.becomeFirstResponder()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        textView.resignFirstResponder()
    }
    
    private func setupLayout() {
        view.addSubview(textView)
        textView.translatesAutoresizingMaskIntoConstraints = false
        
        textView.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor, constant: 15).isActive = true
        textView.bottomAnchor.constraint(equalTo: bottomLayoutGuide.topAnchor, constant: -15).isActive = true
        textView.leadingAnchor.constraint(equalTo: view.readableContentGuide.leadingAnchor, constant: 0).isActive = true
        textView.trailingAnchor.constraint(equalTo: view.readableContentGuide.trailingAnchor, constant: 0).isActive = true
    }
    
    @objc private func keyboardWillShow(notification: NSNotification){
        //give room at the bottom of the scroll view, so it doesn't cover up anything the user needs to tap
        let userInfo = notification.userInfo!
        var keyboardFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        keyboardFrame = self.view.convert(keyboardFrame, from: nil)
        
        var contentInset = self.textView.contentInset
        contentInset.bottom = keyboardFrame.size.height
        self.textView.contentInset = contentInset
    }
    
    @objc private func keyboardWillHide(notification: NSNotification){
        let contentInset:UIEdgeInsets = UIEdgeInsets.zero
        self.textView.contentInset = contentInset
    }
}

extension EditTextAreaFieldViewController: UITextViewDelegate {
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        return true
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        field.value = textView.text
        delegate?.textViewController(self, didUpdateField: field)
    }
}
