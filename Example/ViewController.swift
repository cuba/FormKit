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
            FormSection(title: "Some section", rows: [
                StringField(key: "text_field", label: "Text Field (This may go on seperate lines like this)", type: .text),
                StringField(key: "password_field", label: "Password Field (This may go on seperate lines like this)", type: .password),
                TextAreaField(key: "text_area_field", label: "Text Area Field (This may go on seperate lines like this)"),
                DateField(key: "date_field", label: "Date Field (This may go on seperate lines like this)"),
                BoolField(key: "bool_field", label: "Bool Field (This may go on seperate lines like this)"),
                SingleSelectField(key: "single_selection_field", label: "Single Selection Field (This may go on seperate lines like this)", allItems: SelectionOption.all),
                MultipleSelectField(key: "multi_selection_field", label: "Multiple Selection Field (This may go on seperate lines like this)", allItems: SelectionOption.all),
                NumberField(key: "ingeger_field", label: "Integer Field (This may go on seperate lines like this)", type: .integer),
                NumberField(key: "double_field", label: "Double Field (This may go on seperate lines like this)", type: .decimal),
                ]
            )
        ]
    }
}

