//
//  FormFieldTableViewCell.swift
//  SafetyBoot
//
//  Created by Jacob Sikorski on 2017-03-20.
//  Copyright © 2017 Tamarai. All rights reserved.
//

import Foundation
import UIKit

public protocol FieldDelegate {
    func valueChanged(for field: FormField, at indexPath: IndexPath)
}

public protocol FormFieldCell {
    var tableViewCell: UITableViewCell { get }
    var delegate: FieldDelegate? { get set }
    var indexPath: IndexPath? { get set }
}

open class FormFieldTableViewCell: UITableViewCell, FormFieldCell {
    
    public var tableViewCell: UITableViewCell {
        return self
    }
    
    open var delegate: FieldDelegate?
    open var indexPath: IndexPath?
}

open class LabeledFieldTableViewCell: FormFieldTableViewCell {
    lazy var label: UILabel = {
        let label = UILabel()
        label.configure(with: Style.current.label)
        label.numberOfLines = 0
        return label
    }()
}
