//
//  BasicSignatureField.swift
//  FormKit
//
//  Created by Jacob Sikorski on 2018-08-08.
//  Copyright © 2018 Jacob Sikorski. All rights reserved.
//

import Foundation

public protocol SignatureField: EditableField {
    var image: CGImage? { get set }
}

public struct BasicSignatureField: SignatureField, SavableField {
    public var options: FieldOptions = []
    public var key: String
    public var label: String
    public var image: CGImage?
    
    public func saveValue<T>() -> T? {
        return image as? T
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
