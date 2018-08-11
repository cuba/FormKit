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
}

public struct BasicSelectionOption<T>: SelectionItem {
    public var key: String
    public var label: String
    public var isEnabled: Bool
    public var object: T?
    
    public init(key: String, label: String, isEnabled: Bool = true, object: T? = nil) {
        self.key = key
        self.label = label
        self.isEnabled = isEnabled
        self.object = object
    }
}

public struct MultipleSelectField: EditableField {
    public var options: FieldOptions = []
    private(set) public var key: String
    private(set) public var label: String
    private(set) public var allItems: [SelectionItem]
    public var selectedItems: [SelectionItem] = []
    
    public var hasSelection: Bool {
        return !selectedItems.isEmpty
    }
    
    public var isAllSelected: Bool {
        return selectedItems.count == allItems.count
    }
    
    public var value: String? {
        return selectedItems.map({ $0.label }).joined(separator: ", ")
    }
    
    public var saveValue: Any? {
        return selectedItems
    }
    
    public init(key: String, label: String, allItems: [SelectionItem], selectedItems: [SelectionItem] = []) {
        self.key = key
        self.label = label
        self.allItems = allItems
        self.selectedItems = selectedItems
    }
    
    public init(provider: FieldProvider, allItems: [SelectionItem], selectedItems: [SelectionItem] = []) {
        self.key = provider.key
        self.label = provider.label
        self.options = provider.options
        self.allItems = allItems
        self.selectedItems = selectedItems
    }
    
    public mutating func select(item: SelectionItem) {
        guard !isSelected(item: item) else { return }
        var selectedItems = self.selectedItems
        selectedItems.append(item)
        
        self.selectedItems = allItems.filter({ subItem in
            return selectedItems.contains(where: { $0.key == subItem.key })
        })
    }
    
    public mutating func deselect(item: SelectionItem) {
        guard let index = selectedItems.index(where: { $0.key == item.key }) else { return }
        selectedItems.remove(at: index)
    }
    
    public func isSelected(item: SelectionItem) -> Bool {
        return selectedItems.contains(where: { $0.key == item.key })
    }
    
    public mutating func selectNone() {
        selectedItems = []
    }
    
    public mutating func selectAll() {
        selectedItems = allItems
    }
}

public struct SingleSelectField: EditableField {
    public var options: FieldOptions = []
    private(set) public var key: String
    private(set) public var label: String
    private(set) public var allItems: [SelectionItem]
    public var isClearable = true
    
    public var selectedItem: SelectionItem?
    
    public var hasSelection: Bool {
        return selectedItem != nil
    }
    
    public var value: String? {
        return selectedItem?.label
    }
    
    public var saveValue: Any? {
        return selectedItem
    }
    
    public init(key: String, label: String, allItems: [SelectionItem], selectedItem: SelectionItem? = nil, isClearable: Bool = true) {
        self.key = key
        self.label = label
        self.allItems = allItems
        self.selectedItem = selectedItem
        self.isClearable = isClearable
    }
    
    public init(provider: FieldProvider, allItems: [SelectionItem], selectedItem: SelectionItem? = nil, isClearable: Bool = true) {
        self.key = provider.key
        self.label = provider.label
        self.options = provider.options
        self.allItems = allItems
        self.selectedItem = selectedItem
        self.isClearable = isClearable
    }
    
    public mutating func select(item: SelectionItem) {
        selectedItem = item
    }
    
    public mutating func deselect(item: SelectionItem) {
        guard selectedItem?.key == item.key else { return }
        selectedItem = nil
    }
    
    public func isSelected(item: SelectionItem) -> Bool {
        guard let selectedItem = self.selectedItem else { return false }
        return selectedItem.key == item.key
    }
    
    public mutating func clearSelection() {
        selectedItem = nil
    }
}
