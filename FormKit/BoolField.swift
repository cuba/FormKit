//
//  BoolField.swift
//  SafetyBoot
//
//  Created by Jacob Sikorski on 2017-03-26.
//  Copyright © 2017 Tamarai. All rights reserved.
//

import Foundation

public struct BoolField: EditableField {
    public var fieldOptions: FieldOptions = []
    public var key: String
    public var label: String
    public var isChecked: Bool?
    public var prefix: String?
    
    public init(key: String, label: String, prefix: String? = nil, isChecked: Bool? = nil) {
        self.key = key
        self.label = label
        self.isChecked = isChecked
        self.prefix = prefix
    }
}
