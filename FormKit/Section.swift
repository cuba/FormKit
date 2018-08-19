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

public extension FormRow {
    public func isRow(for provider: FieldProvider) -> Bool {
        return provider.key == self.key
    }
    
    public func isRow(forKey key: String) -> Bool {
        return key == self.key
    }
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

extension SavableField {
    public func isField(for provider: FieldProvider) -> Bool {
        return provider.key == self.key
    }
    
    public func isField(forKey key: String) -> Bool {
        return key == self.key
    }
}

public func <-<T>(left: inout T?, right: (String, SavableField)) {
    let field = right.1
    guard right.0 == field.key else { return }
    left = field.saveValue()
}

public func <-<T>(left: inout T, right: (String, SavableField)) {
    let field = right.1
    guard right.0 == field.key else { return }
    left = field.saveValue() ?? left
}

public func <-<T>(left: inout T?, right: (FieldProvider, SavableField)) {
    let field = right.1
    guard right.0.key == field.key else { return }
    left = field.saveValue()
}

public func <-<T>(left: inout T, right: (FieldProvider, SavableField)) {
    let field = right.1
    guard right.0.key == field.key else { return }
    left = field.saveValue() ?? left
}
