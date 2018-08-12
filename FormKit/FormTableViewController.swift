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
    func performAction(forCustomRow row: FormRow, at indexPath: IndexPath)
    func updatedField(_ field: SavableField, at indexPath: IndexPath)
}

public protocol FormDataSource: class {
    func makeSections() -> [FormSection]
    func cell(forCustomRow formRow: FormRow, at indexPath: IndexPath) -> UITableViewCell
}

open class FormTableViewController: BaseTableViewController {
    public var isChanged = false
    private var currentTextField: UITextField?
    
    open weak var formDelegate: FormDelegate?
    open weak var formDataSource: FormDataSource?
    public var sections: [FormSection] = []
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        setupSections()
    }
    
    override open func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.tableView.reloadData()
    }
    
    open override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        dismissKeyboard()
    }
    
    open func setupSections() {
        self.sections = formDataSource?.makeSections() ?? []
    }
    
    private func valueChanged(for field: EditableField, at indexPath: IndexPath, reloadRow: Bool) {
        isChanged = true
        sections[indexPath.section].rows[indexPath.row] = field
        
        if reloadRow {
            self.tableView.reloadRows(at: [indexPath], with: .none)
        }
        
        if let field = field as? SavableField {
            formDelegate?.updatedField(field, at: indexPath)
        }
    }
    
    public func dismissKeyboard() {
        currentTextField?.resignFirstResponder()
    }
    
    public func reloadData() {
        setupSections()
        tableView.reloadData()
    }
    
    // Mark: - Providers
    
    open func cell(for stringField: StringField, at indexPath: IndexPath) -> StringFieldCellProvider {
        let cell = Cell.input.dequeCell(for: tableView, at: indexPath) as! TextInputTableViewCell
        cell.textInputCellDelegate = self
        cell.delegate = self
        cell.configure(with: stringField)
        return cell
    }
    
    open func cell(for numberField: NumberField, at indexPath: IndexPath) -> NumberFieldCellProvider {
        let cell = Cell.input.dequeCell(for: tableView, at: indexPath) as! TextInputTableViewCell
        cell.textInputCellDelegate = self
        cell.delegate = self
        cell.configure(with: numberField)
        return cell
    }
    
    open func cell(for boolField: BoolField, at indexPath: IndexPath) -> BoolFieldCellProvider {
        let cell = Cell.switch.dequeCell(for: tableView, at: indexPath) as! SwitchTableViewCell
        cell.configure(with: boolField)
        cell.delegate = self
        return cell
    }
    
    open func cell(for dateField: DateField, at indexPath: IndexPath) -> DateFieldCellProvider {
        let cell = Cell.date.dequeCell(for: tableView, at: indexPath) as! DateInputTableViewCell
        cell.configure(with: dateField)
        cell.delegate = self
        return cell
    }
    
    open func cell(for selectField: SingleSelectField, at indexPath: IndexPath) -> SingleSelectFieldCellProvider {
        let cell = Cell.select.dequeCell(for: tableView, at: indexPath) as! SingleSelectTableViewCell
        cell.configure(with: selectField)
        return cell
    }
    
    open func cell(for selectField: MultipleSelectField, at indexPath: IndexPath) -> MultipleSelectFieldCellProvider {
        let cell = Cell.textArea.dequeCell(for: tableView, at: indexPath) as! TextAreaTableViewCell
        cell.configure(with: selectField)
        return cell
    }
    
    open func cell(for textAreaField: TextAreaField, at indexPath: IndexPath) -> TextAreaFieldCellProvider {
        let cell = Cell.textArea.dequeCell(for: tableView, at: indexPath) as! TextAreaTableViewCell
        cell.configure(with: textAreaField)
        return cell
    }
    
    open func cell(for signatureField: SignatureField, at indexPath: IndexPath) -> SignatureFieldCellProvider {
        let cell = Cell.signature.dequeCell(for: tableView, at: indexPath) as! SignatureTableViewCell
        cell.configure(with: signatureField)
        return cell
    }
    
    // MARK: - Actions
    
    open func performAction(for stringField: StringField, at indexPath: IndexPath) {
        guard stringField.isEnabled else { return }
        
        if let cell = tableView.cellForRow(at: indexPath) as? TextInputTableViewCell {
            cell.textField.becomeFirstResponder()
        }
    }
    
    open func performAction(for numberField: NumberField, at indexPath: IndexPath) {
        guard numberField.isEnabled else { return }
        
        if let cell = tableView.cellForRow(at: indexPath) as? TextInputTableViewCell {
            cell.textField.becomeFirstResponder()
        }
    }
    
    open func performAction(for dateField: DateField, at indexPath: IndexPath) {
        guard dateField.isEnabled else { return }
        
        if let cell = tableView.cellForRow(at: indexPath) as? DateInputTableViewCell {
            cell.textField.becomeFirstResponder()
        }
    }
    
    open func performAction(for boolField: BoolField, at indexPath: IndexPath) {
        guard boolField.isEnabled else { return }
        
        guard let cell = tableView.cellForRow(at: indexPath) as? SwitchTableViewCell else { return }
        var boolField = boolField
        let value = !cell.onSwitch.isOn
        cell.onSwitch.setOn(value, animated: true)
        cell.delegate = self
        
        boolField.isChecked = value
        valueChanged(for: boolField, at: indexPath, reloadRow: false)
    }
    
    open func performAction(for singleSelectField: SingleSelectField, at indexPath: IndexPath) {
        guard singleSelectField.isEnabled else { return }
        showOptions(for: singleSelectField, at: indexPath)
    }
    
    open func performAction(for multipleSelectField: MultipleSelectField, at indexPath: IndexPath) {
        guard multipleSelectField.isEnabled else { return }
        let viewController = MultipleSelectionViewController(field: multipleSelectField)
        viewController.selectionDelegate = self
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    open func performAction(for textAreaField: TextAreaField, at indexPath: IndexPath) {
        guard textAreaField.isEnabled else { return }
        let viewController = EditTextAreaFieldViewController(field: textAreaField)
        viewController.delegate = self
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    open func performAction(for signatureField: SignatureField, at indexPath: IndexPath) {
        guard signatureField.isEnabled else { return }
        let viewController = EditSignatureViewController(signatureField: signatureField)
        let navigationController = UINavigationController(rootViewController: viewController)
        viewController.delegate = self
        self.navigationController?.present(navigationController, animated: true, completion: nil)
    }
    
    public func indexPath(for formRow: FormRow) -> IndexPath? {
        guard let section = sections.index(where: { $0.rows.contains(where: { $0.key == formRow.key })}) else { return nil }
        guard let row = sections[section].rows.index(where: { $0.key == formRow.key }) else { return nil }
        
        return IndexPath(row: row, section: section)
    }
}

//MARK: UITableViewControllerDataSource

extension FormTableViewController {
    override open func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    override open func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].rows.count
    }
    
    override open func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = sections[indexPath.section]
        let row = section.rows[indexPath.row]
        return cell(for: row, at: indexPath)
    }
    
    override open func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.1
    }
    
    override open func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section].title
    }
    
    private func cell(for row: FormRow, at indexPath: IndexPath) -> UITableViewCell {
        var cell: FormFieldCellProvider? = nil
        
        switch row {
        case let field as DateField:
            cell = self.cell(for: field, at: indexPath)
        case let field as StringField:
            cell = self.cell(for: field, at: indexPath)
        case let field as NumberField:
            cell = self.cell(for: field, at: indexPath)
        case let field as BoolField:
            cell = self.cell(for: field, at: indexPath)
        case let field as SingleSelectField:
            cell = self.cell(for: field, at: indexPath)
        case let field as MultipleSelectField:
            cell = self.cell(for: field, at: indexPath)
        case let field as TextAreaField:
            cell = self.cell(for: field, at: indexPath)
        case let field as SignatureField:
            cell = self.cell(for: field, at: indexPath)
        default:
            if let cell = formDataSource?.cell(forCustomRow: row, at: indexPath) {
                return cell
            } else {
                assertionFailure("You need to provide a `FormDataSource` for custom cells")
                return UITableViewCell()
            }
        }
        
        if let tableViewCell = cell?.tableViewCell {
            tableViewCell.setNeedsLayout()
            tableViewCell.layoutIfNeeded()
            return tableViewCell
        } else {
            assertionFailure("No cell registered for row \(row)")
            return UITableViewCell()
        }
    }
}

//MARK: UITableViewControllerDelegate

extension FormTableViewController {
    override open func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let section = sections[indexPath.section]
        let row = section.rows[indexPath.row]
        
        switch row {
        case let field as BoolField:
            performAction(for: field, at: indexPath)
        case let field as SingleSelectField:
            performAction(for: field, at: indexPath)
        case let field as MultipleSelectField:
            performAction(for: field, at: indexPath)
        case let field as StringField:
            performAction(for: field, at: indexPath)
        case let field as NumberField:
            performAction(for: field, at: indexPath)
        case let field as DateField:
            performAction(for: field, at: indexPath)
        case let field as TextAreaField:
            performAction(for: field, at: indexPath)
        case let field as SignatureField:
            performAction(for: field, at: indexPath)
        default:
            formDelegate?.performAction(forCustomRow: row, at: indexPath)
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
                
                self.valueChanged(for: field, at: indexPath, reloadRow: true)
            })
            
            action.isEnabled = item.isEnabled && !field.isSelected(item: item)
            alertController.addAction(action)
        }
        
        if field.isClearable {
            alertController.addAction(UIAlertAction(title: "Button.Clear".localized(), style: .default, handler: { action in
                guard let indexPath = self.indexPath(for: field) else { return }
                var field = field
                field.clearSelection()
                
                self.valueChanged(for: field, at: indexPath, reloadRow: true)
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
        
        if indexPath.row + 1 < sections[indexPath.section].rows.count {
            return IndexPath(row: indexPath.row + 1, section: indexPath.section)
        } else if nextSection < sections.count, sections[nextSection].rows.count > 0 {
            return IndexPath(row: 0, section: nextSection)
        } else {
            return nil
        }
    }
    
    private func indexPath(for field: EditableField) -> IndexPath? {
        guard let section = sections.index(where: {
            return $0.rows.contains(where: {
                $0.key == field.key
            })
        }) else { return nil }
        
        guard let row = sections[section].rows.index(where: { $0.key == field.key }) else { return nil }
        return IndexPath(row: row, section: section)
    }
}

extension FormTableViewController: MultipleSelectionViewControllerDelegate {
    func multipleSelectionViewControllerDidUpdate(field: MultipleSelectField) {
        guard let indexPath = self.indexPath(for: field) else { return }
        valueChanged(for: field, at: indexPath, reloadRow: true)
    }
    
    func multipleSelectionViewControllerDidCancel() {
        // Do nothing since we are using the navigation stack
    }
}

extension FormTableViewController: TextInputTableViewCellDelegate {
    func textInputTableViewCell(_ cell: TextInputTableViewCell, didUpdateField field: TextInputField) {
        guard let indexPath = self.indexPath(for: field) else { return }
        valueChanged(for: field, at: indexPath, reloadRow: false)
    }
}

extension FormTableViewController: DateInputTableViewCellDelegate {
    func dateInputTableViewCell(_ cell: DateInputTableViewCell, didUpdateField field: DateField) {
        guard let indexPath = self.indexPath(for: field) else { return }
        valueChanged(for: field, at: indexPath, reloadRow: false)
    }
}

extension FormTableViewController: EditTextAreaFieldViewControllerDelegate {
    func textViewController(_ textViewController: EditTextAreaFieldViewController, didUpdateField textAreaField: TextAreaField) {
        guard let indexPath = self.indexPath(for: textAreaField) else { return }
        valueChanged(for: textAreaField, at: indexPath, reloadRow: true)
    }
}

extension FormTableViewController: EditSignatureViewControllerDelegate {
    func editSignatureViewControllerDidCancel(_ controller: EditSignatureViewController) {
        navigationController?.dismiss(animated: true, completion: nil)
    }
    
    func editSignatureViewController(_ controller: EditSignatureViewController, didUpdateField signatureField: SignatureField) {
        navigationController?.dismiss(animated: true, completion: nil)
        guard let indexPath = self.indexPath(for: signatureField) else { return }
        valueChanged(for: signatureField, at: indexPath, reloadRow: true)
    }
}

extension FormTableViewController: SwitchTableViewCellDelegate {
    func switchTableViewCell(_ cell: SwitchTableViewCell, didUpdateField field: BoolField) {
        guard let indexPath = self.indexPath(for: field) else { return }
        valueChanged(for: field, at: indexPath, reloadRow: false)
    }
}
