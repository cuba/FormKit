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
    func valueChanged(for field: EditableField, at indexPath: IndexPath)
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
