//
//  SignatureField.swift
//  FormKit
//
//  Created by Jacob Sikorski on 2018-08-08.
//  Copyright © 2018 Jacob Sikorski. All rights reserved.
//

import Foundation

public struct SignatureField: EditableField {
    public var options: FieldOptions = []
    public var key: String
    public var label: String
    public var image: CGImage?
    
    public var saveValue: Any? {
        return image
    }
    
    public init(key: String, label: String, image: CGImage? = nil) {
        self.key = key
        self.label = label
        self.image = image
    }
    
    public init(provider: FieldProvider, image: CGImage? = nil) {
        self.key = provider.key
        self.label = provider.label
        self.options = provider.options
        self.image = image
    }
}
