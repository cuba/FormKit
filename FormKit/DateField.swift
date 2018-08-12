//
//  DateField.swift
//  SafetyBoot
//
//  Created by Jacob Sikorski on 2017-03-26.
//  Copyright © 2017 Tamarai. All rights reserved.
//

import Foundation

public enum DateFieldType {
    case date
    case time
    case dateTime
}

public struct DateField: InputField, SavableField {
    public var options: FieldOptions = []
    
    private(set) public var key: String
    private(set) public var label: String
    
    static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .full
        formatter.timeStyle = .none
        return formatter
    }()
    
    static let dateTimeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .full
        formatter.timeStyle = .full
        return formatter
    }()
    
    static let timeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .none
        formatter.timeStyle = .full
        return formatter
    }()
    
    public var date: Date?
    public var type: DateFieldType = .date
    
    public func saveValue<T>() -> T? {
        return date as? T
    }
    
    public var formatter: DateFormatter {
        switch type {
        case .date:
            return DateField.dateFormatter
        case .time:
            return DateField.timeFormatter
        case .dateTime:
            return DateField.dateTimeFormatter
        }
    }
    
    public var value: String? {
        if let date = self.date {
            let formatter = self.formatter
            return formatter.string(from: date)
        } else {
            return nil
        }
    }
    
    public init(key: String, label: String, date: Date? = nil, options: FieldOptions = []) {
        self.key = key
        self.label = label
        self.date = date
        self.options = options
    }
    
    public init(provider: FieldProvider, type: DateFieldType, date: Date?) {
        self.key = provider.key
        self.label = provider.label
        self.options = provider.options
        self.type = type
        self.date = date
    }
}
