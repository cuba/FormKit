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

class ViewController: FormTableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Example Form"
    }
    
    override func setupSections() {
        sections = [
            FormSection(title: "Some section", fields: [
                StringField(key: "text_field", label: "Text Field", type: .text),
                StringField(key: "password_field", label: "Password Field", type: .password),
                DateField(key: "date_field", label: "Date Field"),
                BoolField(key: "bool_field", label: "Bool Field"),
                SingleSelectField(key: "single_selection_field", label: "Single Selection Field", allItems: SelectionOption.all),
                MultipleSelectField(key: "multi_selection_field", label: "Multile Selection Field", allItems: SelectionOption.all),
                NumberField(key: "ingeger_field", label: "Integer Field", type: .integer),
                NumberField(key: "double_field", label: "Double Field", type: .decimal),
                ]
            )
        ]
    }
}

