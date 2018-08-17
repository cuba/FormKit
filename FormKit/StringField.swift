//
//  BasicStringField.swift
//  SafetyBoot
//
//  Created by Jacob Sikorski on 2017-03-26.
//  Copyright © 2017 Tamarai. All rights reserved.
//

import Foundation

public enum StringFieldType {
    case text
    case password
}

public protocol StringField: TextInputField {
    var type: StringFieldType { get }
    var value: String? { get set }
}

public struct BasicStringField: StringField, SavableField {
    public var options: FieldOptions = []
    
    private(set) public var key: String
    private(set) public var label: String
    
    public var type = StringFieldType.text
    public var value: String?
    
    public func saveValue<T>() -> T? {
        return value as? T
    }
    
    public init(key: String, label: String, type: StringFieldType = .text, value: String? = nil) {
        self.key = key
        self.label = label
        self.type = type
        self.value = value
    }
    
    public init(provider: FieldProvider, type: StringFieldType, value: String?) {
        self.key = provider.key
        self.label = provider.label
        self.options = provider.options
        self.type = type
        self.value = value
    }
    
    public mutating func set(value: String?) {
        self.value = value
    }
}
