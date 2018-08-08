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
    var tableViewCell: FormFieldTableViewCell { get }
}

open class FormFieldTableViewCell: UITableViewCell {
    open var delegate: FieldDelegate?
    open var indexPath: IndexPath?
}
