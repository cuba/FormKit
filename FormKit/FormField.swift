//
//  Fields.swift
//  SafetyBoot
//
//  Created by Jacob Sikorski on 2017-03-26.
//  Copyright © 2017 Tamarai. All rights reserved.
//

import Foundation

public struct FieldOptions: OptionSet {
    public let rawValue: Int
    
    public init(rawValue: Int) {
        self.rawValue = rawValue
    }
    
    public static let required = FieldOptions(rawValue: 1 << 0)
    public static let disabled = FieldOptions(rawValue: 1 << 1)
}

public protocol FormField {
    var key: String { get}
}

public protocol EditableField: FormField {
    var label: String { get }
    var fieldOptions: FieldOptions { get }
}

extension EditableField {
    var isRequired: Bool {
        return fieldOptions.contains(.required)
    }
    
    var isEnabled: Bool {
        return !fieldOptions.contains(.disabled)
    }
}

public protocol TextField: EditableField {
    var value: String? { get }
}

public protocol TextInputField: TextField {
    mutating func set(value: String?)
}
