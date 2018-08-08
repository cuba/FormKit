//
//  FormTableViewController.swift
//  SafetyBoot
//
//  Created by Jacob Sikorski on 2017-03-20.
//  Copyright © 2017 Tamarai. All rights reserved.
//

import Foundation
import UIKit

public protocol FormDelegate: class {
    func valueChanged(for field: FormField, at indexPath: IndexPath)
}

open class FormTableViewController: BaseTableViewController, FieldDelegate {
    public private(set) var changed = false
    public private(set) var currentTextField: UITextField?
    public weak var formDelegate: FormDelegate?
    public var sections: [FormSection] = []
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        setupSections()
    }
    
    override open func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.tableView.reloadData()
    }
    
    open func setupSections() {
        // empty implementation
    }
    
    public func valueChanged(for field: FormField, at indexPath: IndexPath) {
        changed = true
        sections[indexPath.section].fields[indexPath.row] = field
        let cell = tableView.cellForRow(at: indexPath)
        
        if !(cell is TextInputTableViewCell || cell is DateInputTableViewCell || cell is SwitchTableViewCell) {
            tableView.reloadRows(at: [indexPath], with: .none)
        }
        
        formDelegate?.valueChanged(for: field, at: indexPath)
    }
    
    public func dismissKeyboard() {
        currentTextField?.resignFirstResponder()
    }
    
    public func reloadData() {
        setupSections()
        tableView.reloadData()
    }
}

//MARK: UITableViewControllerDataSource

extension FormTableViewController {
    override open func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    override open func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].fields.count
    }
    
    override open func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = sections[indexPath.section]
        let field = section.fields[indexPath.row]
        return cell(for: field, at: indexPath)
    }
    
    private func cell(for field: FormField, at indexPath: IndexPath) -> UITableViewCell {
        var cell: FormFieldCell? = nil
        
        if let dateField = field as? DateField {
            cell = self.cell(for: dateField, at: indexPath)
        } else if let stringField = field as? StringField {
            cell = self.cell(for: stringField, at: indexPath)
        } else if let stringField = field as? NumberField {
            cell = self.cell(for: stringField, at: indexPath)
        } else if let boolField = field as? BoolField {
            cell = self.cell(for: boolField, at: indexPath)
        } else if let selectField = field as? SelectField {
            cell = self.cell(for: selectField, at: indexPath)
        }
        
        if let cell = cell?.cell {
            cell.delegate = self
            cell.indexPath = indexPath
            cell.setNeedsLayout()
            cell.layoutIfNeeded()
            
            return cell
        } else {
            assertionFailure("No cell registered for field \(field)")
            return UITableViewCell()
        }
    }
    
    private func cell(for stringField: StringField, at indexPath: IndexPath) -> FormFieldCell {
        var cell = Cell.input.dequeCell(for: tableView, at: indexPath) as! TextInputFieldCell
        cell.textInputCellDelegate = self
        cell.setup(for: stringField)
        return cell
    }
    
    private func cell(for numberField: NumberField, at indexPath: IndexPath) -> FormFieldCell {
        var cell = Cell.input.dequeCell(for: tableView, at: indexPath) as! TextInputFieldCell
        cell.textInputCellDelegate = self
        cell.setup(for: numberField)
        return cell
    }
    
    private func cell(for boolField: BoolField, at indexPath: IndexPath) -> FormFieldCell {
        let cell = Cell.switch.dequeCell(for: tableView, at: indexPath) as! BoolFieldCell
        cell.setup(for: boolField)
        return cell
    }
    
    private func cell(for dateField: DateField, at indexPath: IndexPath) -> FormFieldCell {
        let cell = Cell.date.dequeCell(for: tableView, at: indexPath) as! DateFieldCell
        cell.setup(for: dateField)
        return cell
    }
    
    private func cell(for selectField: SelectField, at indexPath: IndexPath) -> FormFieldCell {
        let cell = Cell.select.dequeCell(for: tableView, at: indexPath) as! SelectFieldCell
        cell.setup(for: selectField)
        return cell
    }
    
    override open func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section].title
    }
}

//MARK: UITableViewControllerDelegate

extension FormTableViewController {
    override open func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let section = sections[indexPath.section]
        let field = section.fields[indexPath.row]
        
        if let field = field as? BoolField {
            performAction(for: field, at: indexPath)
        } else if let field = field as? SelectField {
            performAction(for: field, at: indexPath)
        } else if let field = field as? StringField {
            performAction(for: field, at: indexPath)
        } else if let field = field as? NumberField {
            performAction(for: field, at: indexPath)
        } else if let field = field as? DateField {
            performAction(for: field, at: indexPath)
        } else {
            
        }
    }
    
    private func performAction(for stringField: StringField, at indexPath: IndexPath) {
        
        if let cell = tableView.cellForRow(at: indexPath) as? TextInputTableViewCell {
            cell.textField.becomeFirstResponder()
        }
    }
    
    private func performAction(for numberField: NumberField, at indexPath: IndexPath) {
        
        if let cell = tableView.cellForRow(at: indexPath) as? TextInputTableViewCell {
            cell.textField.becomeFirstResponder()
        }
    }
    
    private func performAction(for dateField: DateField, at indexPath: IndexPath) {
        
        if let cell = tableView.cellForRow(at: indexPath) as? DateInputTableViewCell {
            cell.textField.becomeFirstResponder()
        }
    }
    
    private func performAction(for boolField: BoolField, at indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? SwitchTableViewCell else { return }
        var boolField = boolField
        let value = !cell.onSwitch.isOn
        cell.onSwitch.setOn(value, animated: true)
        
        boolField.value = value
        valueChanged(for: boolField, at: indexPath)
    }
    
    private func performAction(for field: SelectField, at indexPath: IndexPath) {
        switch field {
        case let field as SingleSelectField:
            showOptions(for: field, at: indexPath)
        case let field as MultipleSelectField:
            let viewController = MultipleSelectionViewController(field: field)
            viewController.selectionDelegate = self
            navigationController?.pushViewController(viewController, animated: true)
        default:
            return
        }
    }
    
    private func showOptions(for field: SingleSelectField, at indexPath: IndexPath) {
        let alertController = UIAlertController(title: "Label.SelectOne".localized(), message: nil, preferredStyle: .actionSheet)
        alertController.popoverPresentationController?.sourceView = tableView
        alertController.popoverPresentationController?.sourceRect = tableView.rectForRow(at: indexPath)
        alertController.popoverPresentationController?.permittedArrowDirections = .any
        
        for item in field.allItems {
            let action = UIAlertAction(title: item.label, style: .default, handler: { action in
                guard let indexPath = self.indexPath(for: field) else { return }
                var field = field
                field.select(item: item)
                
                self.sections[indexPath.section].fields[indexPath.row] = field
                self.tableView.reloadRows(at: [indexPath], with: .none)
                self.formDelegate?.valueChanged(for: field, at: indexPath)
            })
            
            action.isEnabled = item.isEnabled && !field.isSelected(item: item)
            alertController.addAction(action)
        }
        
        if field.isClearable {
            alertController.addAction(UIAlertAction(title: "Button.Clear".localized(), style: .default, handler: { action in
                guard let indexPath = self.indexPath(for: field) else { return }
                var field = field
                field.clearSelection()
                
                self.sections[indexPath.section].fields[indexPath.row] = field
                self.tableView.reloadRows(at: [indexPath], with: .none)
                self.formDelegate?.valueChanged(for: field, at: indexPath)
            }))
        }
        
        alertController.addAction(UIAlertAction(title: "Button.Cancel".localized(), style: .cancel, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
}

extension FormTableViewController: TextInputTableViewDelegate {
    public func textFieldDidBeginEditing(_ textField: UITextField, for cell: TextInputTableViewCell) {
        self.currentTextField = textField
    }
    
    public func textFieldDidEndEditing(_ textField: UITextField, for cell: TextInputTableViewCell) {
        self.currentTextField = nil
    }
    
    public func textFieldShouldReturn(for cell: TextInputTableViewCell) -> Bool {
        guard let indexPath = tableView.indexPath(for: cell) else { return true }
        
        if let indexPath = nextIndexPath(for: indexPath), let cell = tableView.cellForRow(at: indexPath) as? TextInputTableViewCell {
            cell.textField.becomeFirstResponder()
        } else {
            cell.textField.resignFirstResponder()
        }
        
        return true
    }
    
    private func nextIndexPath(for indexPath: IndexPath) -> IndexPath? {
        let nextSection = indexPath.section + 1
        
        if indexPath.row + 1 < sections[indexPath.section].fields.count {
            return IndexPath(row: indexPath.row + 1, section: indexPath.section)
        } else if nextSection < sections.count, sections[nextSection].fields.count > 0 {
            return IndexPath(row: 0, section: nextSection)
        } else {
            return nil
        }
    }
    
    private func indexPath(for field: FormField) -> IndexPath? {
        guard let section = sections.index(where: { $0.fields.contains(where: { $0.key == field.key }) }) else { return nil }
        guard let row = sections[section].fields.index(where: { $0.key == field.key }) else { return nil }
        
        return IndexPath(row: row, section: section)
    }
}

extension FormTableViewController: MultipleSelectionViewControllerDelegate {
    func multipleSelectionViewControllerDidUpdate(field: MultipleSelectField) {
        guard let indexPath = self.indexPath(for: field) else { return }
        self.sections[indexPath.section].fields[indexPath.row] = field
        self.tableView.reloadRows(at: [indexPath], with: .none)
        self.formDelegate?.valueChanged(for: field, at: indexPath)
    }
    
    func multipleSelectionViewControllerDidCancel() {
        // Do nothing since we are using the navigation stack
    }
}
