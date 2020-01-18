//
//  MultipleSelectionViewController.swift
//  FormKit
//
//  Created by Jacob Sikorski on 2018-08-07.
//  Copyright © 2018 Jacob Sikorski. All rights reserved.
//

import UIKit

protocol MultipleSelectionViewControllerDelegate: class {
    func multipleSelectionViewControllerDidUpdate(field: MultipleSelectField)
}

class MultipleSelectionViewController: BaseTableViewController {
    private(set) var field: MultipleSelectField
    weak var selectionDelegate: MultipleSelectionViewControllerDelegate?
    
    init(field: MultipleSelectField) {
        self.field = field
        super.init(style: .plain)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return field.allItems.count + 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = CellProvider.standard.dequeCell(for: tableView, at: indexPath)
        
        if let item = selectionItem(at: indexPath) {
            cell.accessoryType = field.isSelected(item: item) ? .checkmark : .none
            cell.textLabel?.text = item.label
            return cell
        } else {
            cell.accessoryType = field.isAllSelected ? .checkmark : .none
            cell.textLabel?.text = "Label.SelectAll".localized()
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if let item = selectionItem(at: indexPath) {
            toggleSelection(for: item, at: indexPath)
        } else {
            toggleSelectAll()
        }
    }
    
    private func selectionItem(at indexPath: IndexPath) -> SelectionItem? {
        let index = indexPath.row - 1
        guard index >= 0 else { return nil }
        return field.allItems[index]
    }
    
    private func index(of item: SelectionItem) -> Int? {
        guard var index = field.allItems.firstIndex(where: { $0.key == item.key }) else { return nil }
        index = index + 1
        guard index >= 0 else { return nil }
        
        return index
    }
    
    private func toggleSelection(for item: SelectionItem, at indexPath: IndexPath) {
        if field.isSelected(item: item) {
            field.deselect(item: item)
        } else {
            field.select(item: item)
        }
        
        let indexPaths = [IndexPath(row: 0, section: 0), indexPath]
        tableView.reloadRows(at: indexPaths, with: .automatic)
        
        selectionDelegate?.multipleSelectionViewControllerDidUpdate(field: field)
    }
    
    private func toggleSelectAll() {
        if field.isAllSelected {
            field.selectNone()
        } else {
            field.selectAll()
        }
        
        tableView.reloadData()
        selectionDelegate?.multipleSelectionViewControllerDidUpdate(field: field)
    }
}
