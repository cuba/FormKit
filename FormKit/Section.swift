//
//  FormSection.swift
//  SafetyBoot
//
//  Created by Jacob Sikorski on 2017-03-24.
//  Copyright © 2017 Tamarai. All rights reserved.
//

import Foundation

infix operator <-

// MARK: - Section

public struct FormSection {
    public var title: String?
    public var rows: [FormRow] = []
    
    public init(title: String? = nil, rows: [FormRow]) {
        self.title = title
        self.rows = rows
    }
}

// MARK: - Fields

public struct FieldOptions: OptionSet {
    public let rawValue: Int
    
    public init(rawValue: Int) {
        self.rawValue = rawValue
    }
    
    public static let required = FieldOptions(rawValue: 1 << 0)
    public static let disabled = FieldOptions(rawValue: 1 << 1)
}

public protocol FieldProvider {
    var key: String { get }
    var label: String { get }
    var options: FieldOptions { get }
}

public protocol FormRow {
    var key: String { get }
}

public protocol EditableField: FormRow {
    var label: String { get }
    var options: FieldOptions { get }
}

public extension EditableField {
    public var isRequired: Bool {
        return options.contains(.required)
    }
    
    public var isEnabled: Bool {
        return !options.contains(.disabled)
    }
}

public protocol InputField: EditableField {
    var value: String? { get }
}

public protocol TextInputField: InputField {
    mutating func set(value: String?)
}

public protocol SavableField {
    var key: String { get }
    func saveValue<T>() -> T?
}

public protocol FieldMappable {
    mutating func map(field: SavableField)
}

public func <-<T>(left: inout T?, right: (String, SavableField)) {
    let key = right.0
    let field = right.1
    
    if field.key == key {
        left = field.saveValue()
    }
}

public func <-<T>(left: inout T, right: (String, SavableField)) {
    let key = right.0
    let field = right.1
    
    if field.key == key {
        left = field.saveValue() ?? left
    }
}

public func <-<T>(left: inout T?, right: (FieldProvider, SavableField)) {
    let key = right.0.key
    let field = right.1
    
    if field.key == key {
        left = field.saveValue()
    }
}

public func <-<T>(left: inout T, right: (FieldProvider, SavableField)) {
    let key = right.0.key
    let field = right.1
    
    if field.key == key {
        left = field.saveValue() ?? left
    }
}
