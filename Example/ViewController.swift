//
//  ViewController.swift
//  Example
//
//  Created by Jacob Sikorski on 2018-08-06.
//  Copyright © 2018 Jacob Sikorski. All rights reserved.
//

import UIKit
import FormKit

enum SelectionOption: String, SelectionItem {
    static let all: [SelectionOption] = [.first, .second, .third, .fourth]
    
    case first  = "first"
    case second = "second"
    case third  = "third"
    case fourth = "fourth"
    
    var key: String {
        return rawValue
    }
    
    var label: String {
        switch self {
        case .first:    return "First Option"
        case .second:   return "Second Option"
        case .third:    return "Third Option"
        case .fourth:   return "Fourt Option"
        }
    }
    
    var isEnabled: Bool {
        return true
    }
    
    var saveValue: Any? {
        return self
    }
}

enum ExampleFieldProvider: String, FieldProvider {
    
    case title              = "title"
    case password           = "password"
    case description        = "description"
    case dateTime           = "date_time"
    case time               = "time"
    case date               = "date"
    case isOn               = "isOn"
    case selectOne          = "selectOne"
    case selectMultiple     = "selectMultiple"
    case age                = "age"
    case amount             = "amount"
    case signature          = "signature"
    case signature2         = "signature_2"
    
    var key: String {
        return rawValue
    }
    
    var label: String {
        switch self {
        case .title             : return "Title"
        case .password          : return "Password"
        case .description       : return "Description"
        case .dateTime          : return "Date Time"
        case .date              : return "Date"
        case .time              : return "Time"
        case .isOn              : return "Do you like this framework?"
        case .selectOne         : return "Select one"
        case .selectMultiple    : return "Select multiple"
        case .age               : return "Age (Years)"
        case .amount            : return "Amount"
        case .signature         : return "Click to enter your signature"
        case .signature2        : return "Click to enter another signature"
        }
    }
    
    var options: FieldOptions {
        return [.required]
    }
}

struct Example: FieldMappable {
    var title: String?
    var password: String?
    var description: String?
    var dateTime: Date?
    var time: Date?
    var date: Date?
    var isOn: Bool?
    var selectOne: SelectionOption?
    var selectMultiple: [SelectionOption] = []
    var age: Int?
    var amount: Double?
    var signature: CGImage?
    var signature2: CGImage?
    
    init() {}
    
    mutating func map(field: SavableField) {
        title           <- (ExampleFieldProvider.title, field)
        password        <- (ExampleFieldProvider.password, field)
        description     <- (ExampleFieldProvider.description, field)
        dateTime        <- (ExampleFieldProvider.dateTime, field)
        time            <- (ExampleFieldProvider.time, field)
        date            <- (ExampleFieldProvider.date, field)
        isOn            <- (ExampleFieldProvider.isOn, field)
        selectOne       <- (ExampleFieldProvider.selectOne, field)
        selectMultiple  <- (ExampleFieldProvider.selectMultiple, field)
        age             <- (ExampleFieldProvider.age, field)
        amount          <- (ExampleFieldProvider.amount, field)
        signature       <- (ExampleFieldProvider.signature, field)
        signature2       <- (ExampleFieldProvider.signature2, field)
    }
}

class ViewController: FormTableViewController {
    
    var example: Example
    
    init() {
        self.example = Example()
        super.init(style: .grouped)
        self.formDelegate = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Example Form"
    }
}

extension ViewController: FormDataSource {
    func makeSections() -> [FormSection] {
        return [
            FormSection(title: "Strings", rows: [
                StringField(provider: ExampleFieldProvider.password, type: .password, value: example.password),
                StringField(provider: ExampleFieldProvider.title, type: .text, value: example.title),
                TextAreaField(provider: ExampleFieldProvider.description, value: example.password)
                ]),
            
            FormSection(title: "Dates", rows: [
                DateField(provider: ExampleFieldProvider.date, type: .date, date: example.date),
                DateField(provider: ExampleFieldProvider.time, type: .time, date: example.time),
                DateField(provider: ExampleFieldProvider.dateTime, type: .dateTime, date: example.dateTime)
                ]),
            
            FormSection(title: "Numbers", rows: [
                NumberField(provider: ExampleFieldProvider.age, amount: example.age),
                NumberField(provider: ExampleFieldProvider.amount, amount: example.amount)
                ]),
            
            FormSection(title: "Toggles", rows: [
                BoolField(provider: ExampleFieldProvider.isOn, isChecked: example.isOn)
                ]),
            
            FormSection(title: "Selections", rows: [
                SingleSelectField(provider: ExampleFieldProvider.selectOne, allItems: SelectionOption.all, selectedItem: example.selectOne),
                MultipleSelectField(provider: ExampleFieldProvider.selectMultiple, allItems: SelectionOption.all, selectedItems: example.selectMultiple)
                ]),
            
            FormSection(title: "Signatures", rows: [
                SignatureField(provider: ExampleFieldProvider.signature, image: example.signature),
                SignatureField(provider: ExampleFieldProvider.signature2, image: example.signature2)
                ]),
            
            FormSection(title: "Static Content", rows: [
                StandardField(key: "standard", title: "Standard Cell", subtitle: nil, accessoryType: .disclosureIndicator),
                StandardField(key: "subtitle", title: "Standard Cell With Subtitle", subtitle: "Some subtitle", accessoryType: .disclosureIndicator)
                ])
        ]
    }
    
    func cell(forCustomRow formRow: FormRow, at indexPath: IndexPath) -> UITableViewCell {
        // Provide cells for your custom rows
        fatalError("You need to provide a UITableViewCell for custom FormRows")
    }
}

extension ViewController: FormDelegate {
    func updatedField(_ field: SavableField, at indexPath: IndexPath) {
        // Handle any mapping to your model
        example.map(field: field)
    }
    
    func performAction(forCustomRow row: FormRow, at indexPath: IndexPath) {
        // Implement a custom action on a row
    }
}

