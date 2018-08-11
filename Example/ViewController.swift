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
    
    init() {}
    
    mutating func map(field: EditableField) {
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
    
    override func setupSections() {
        sections = [
            FormSection(title: "Section Title", rows: [
                StringField(provider: ExampleFieldProvider.title, type: .text, value: example.title),
                StringField(provider: ExampleFieldProvider.password, type: .password, value: example.password),
                TextAreaField(provider: ExampleFieldProvider.description, value: example.password),
                DateField(provider: ExampleFieldProvider.date, type: .date, date: example.date),
                DateField(provider: ExampleFieldProvider.time, type: .time, date: example.time),
                DateField(provider: ExampleFieldProvider.dateTime, type: .dateTime, date: example.dateTime),
                BoolField(provider: ExampleFieldProvider.isOn, isChecked: example.isOn),
                SingleSelectField(provider: ExampleFieldProvider.selectOne, allItems: SelectionOption.all, selectedItem: example.selectOne),
                MultipleSelectField(provider: ExampleFieldProvider.selectMultiple, allItems: SelectionOption.all, selectedItems: example.selectMultiple),
                NumberField(provider: ExampleFieldProvider.age, amount: example.age),
                NumberField(provider: ExampleFieldProvider.amount, amount: example.amount),
                ]
            )
        ]
    }
}

extension ViewController: FormDelegate {
    func updatedField(_ field: EditableField, at indexPath: IndexPath) {
        // Handle any mapping to your model
        example.map(field: field)
        
        // Add any custom logic after changing a value especially for custom cells
        print(example)
    }
    
    func performAction(forCustomRow row: FormRow, at indexPath: IndexPath) {
        // Implement a custom action on a row
    }
}

