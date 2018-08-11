//
//  BoolField.swift
//  SafetyBoot
//
//  Created by Jacob Sikorski on 2017-03-26.
//  Copyright © 2017 Tamarai. All rights reserved.
//

import Foundation

public struct BoolField: EditableField {
    public var options: FieldOptions = []
    
    private(set) public var key: String
    private(set) public var label: String
    
    public var isChecked: Bool?
    
    public var saveValue: Any? {
        return isChecked
    }
    
    public init(key: String, label: String, isChecked: Bool? = nil) {
        self.key = key
        self.label = label
        self.isChecked = isChecked
    }
    
    init(provider: FieldProvider, isChecked: Bool?) {
        self.key = provider.key
        self.label = provider.label
        self.options = provider.options
        self.isChecked = isChecked
    }
}
