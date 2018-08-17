//
//  SelectField.swift
//  SafetyBoot
//
//  Created by Jacob Sikorski on 2017-03-28.
//  Copyright © 2017 Tamarai. All rights reserved.
//

import Foundation

public enum SelectFieldType {
    case single
    case multiple
}

public protocol SelectionItem {
    var key: String { get }
    var label: String { get }
    var isEnabled: Bool { get }
    var saveValue: Any? { get }
}

public struct BasicSelectionOption<T>: SelectionItem {
    public var key: String
    public var label: String
    public var isEnabled: Bool
    public var object: T?
    
    public var saveValue: Any? {
        return object
    }
    
    public init(key: String, label: String, isEnabled: Bool = true, object: T? = nil) {
        self.key = key
        self.label = label
        self.isEnabled = isEnabled
        self.object = object
    }
}
