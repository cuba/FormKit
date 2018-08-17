//
//  SingleSelectField.swift
//  FormKit
//
//  Created by Jacob Sikorski on 2018-08-16.
//  Copyright © 2018 Jacob Sikorski. All rights reserved.
//

import Foundation

public protocol SingleSelectField: EditableField {
    var allItems: [SelectionItem] { get }
    var selectedItem: SelectionItem? { get }
    var isClearable: Bool { get }
    var value: String? { get }
    
    func isSelected(item: SelectionItem) -> Bool
    mutating func select(item: SelectionItem)
    mutating func deselect(item: SelectionItem)
    mutating func clearSelection()
}

public struct BasicSingleSelectField: SingleSelectField, SavableField {
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
    
    public func saveValue<T>() -> T? {
        return selectedItem?.saveValue as? T
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
