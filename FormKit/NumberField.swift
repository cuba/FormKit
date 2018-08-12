//
//  NumberField.swift
//  SafetyBoot
//
//  Created by Jacob Sikorski on 2017-04-03.
//  Copyright © 2017 Jacob Sikorski. All rights reserved.
//

import Foundation

public enum NumberFieldType {
    case integer
    case decimal
}

public struct NumberField: TextInputField, SavableField {
    public var options: FieldOptions = []
    private(set) public var key: String
    private(set) public var label: String
    
    public var type: NumberFieldType
    public var amount: Double?
    
    public var integerAmount: Int? {
        guard let value = self.amount else { return nil }
        return Int(value)
    }
    
    public var value: String? {
        switch type {
        case .integer:
            guard let value = self.integerAmount else { return nil }
            return String(value)
        case .decimal:
            guard let value = self.amount else { return nil}
            return String(value)
        }
    }
    
    public func saveValue<T>() -> T? {
        switch type {
        case .integer: return integerAmount as? T
        case .decimal: return amount as? T
        }
    }
    
    public init(key: String, label: String, type: NumberFieldType) {
        self.key = key
        self.label = label
        self.type = type
    }
    
    public init(key: String, label: String, amount: Double? = nil) {
        self.init(key: key, label: label, type: .decimal)
        self.amount = amount
    }
    
    public init(key: String, label: String, amount: Int? = nil) {
        self.init(key: key, label: label, type: .integer)
        
        if let amount = amount {
            self.amount = Double(amount)
        }
    }
    
    public init(provider: FieldProvider, type: NumberFieldType) {
        self.key = provider.key
        self.label = provider.label
        self.options = provider.options
        self.type = type
    }
    
    public init(provider: FieldProvider, amount: Double?) {
        self.init(provider: provider, type: .decimal)
        self.amount = amount
    }
    
    public init(provider: FieldProvider, amount: Int?) {
        self.init(provider: provider, type: .integer)
        
        if let amount = amount {
            self.amount = Double(amount)
        }
    }
    
    public mutating func set(value: String?) {
        guard let value = value else {
            amount = nil
            return
        }
        
        self.amount = Double(value)
    }
}
