//
//  MultipleSelectField.swift
//  FormKit
//
//  Created by Jacob Sikorski on 2018-08-16.
//  Copyright © 2018 Jacob Sikorski. All rights reserved.
//

import Foundation

public protocol MultipleSelectField: EditableField {
    var allItems: [SelectionItem] { get }
    var value: String? { get }
    var isAllSelected: Bool { get }
    
    func isSelected(item: SelectionItem) -> Bool
    mutating func select(item: SelectionItem)
    mutating func deselect(item: SelectionItem)
    mutating func selectNone()
    mutating func selectAll()
}

public struct BasicMultipleSelectField: MultipleSelectField, SavableField {
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
    
    public func saveValue<T>() -> T? {
        return selectedItems.map({ $0.saveValue }) as? T
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
