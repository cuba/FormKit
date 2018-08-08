//
//  StringField.swift
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

public struct StringField: TextInputField {
    public var fieldOptions: FieldOptions = []
    
    public var key: String
    public var label: String
    public var type = StringFieldType.text
    public var value: String?
    
    public init(key: String, label: String, type: StringFieldType = .text, value: String? = nil) {
        self.key = key
        self.label = label
        self.type = type
        self.value = value
    }
    
    public mutating func set(value: String?) {
        self.value = value
    }
}
