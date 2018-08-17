//
//  BasicTextAreaField.swift
//  FormKit
//
//  Created by Jacob Sikorski on 2018-08-07.
//  Copyright © 2018 Jacob Sikorski. All rights reserved.
//

import Foundation

public protocol TextAreaField: TextInputField {
    var value: String? { get set }
}

public struct BasicTextAreaField: TextAreaField, SavableField {
    public var options: FieldOptions = []
    
    private(set) public var key: String
    private(set) public var label: String
    public var value: String?

    public func saveValue<T>() -> T? {
        return value as? T
    }
    
    public init(key: String, label: String, value: String? = nil) {
        self.key = key
        self.label = label
        self.value = value
    }
    
    public init(provider: FieldProvider, value: String?) {
        self.key = provider.key
        self.label = provider.label
        self.options = provider.options
        self.value = value
    }
    
    public mutating func set(value: String?) {
        self.value = value
    }
}
