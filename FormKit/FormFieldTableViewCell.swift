//
//  FormFieldTableViewCell.swift
//  SafetyBoot
//
//  Created by Jacob Sikorski on 2017-03-20.
//  Copyright © 2017 Tamarai. All rights reserved.
//

import Foundation
import UIKit

public protocol FieldDelegate: class {
    func valueChanged(for field: EditableField, at indexPath: IndexPath)
}

public protocol FormFieldCellProvider {
    var tableViewCell: UITableViewCell { get }
    var delegate: FieldDelegate? { get set }
    var indexPath: IndexPath? { get set }
}

open class FormFieldTableViewCell: UITableViewCell, FormFieldCellProvider {
    
    public var tableViewCell: UITableViewCell {
        return self
    }
    
    open weak var delegate: FieldDelegate?
    open var indexPath: IndexPath?
}
