//
//  TextAreaField.swift
//  FormKit
//
//  Created by Jacob Sikorski on 2018-08-07.
//  Copyright © 2018 Jacob Sikorski. All rights reserved.
//

import Foundation

public struct TextAreaField: TextInputField {
    public var fieldOptions: FieldOptions = []
    
    public var key: String
    public var label: String
    public var value: String?
    
    public init(key: String, label: String, value: String? = nil) {
        self.key = key
        self.label = label
        self.value = value
    }
    
    public mutating func set(value: String?) {
        self.value = value
    }
}
