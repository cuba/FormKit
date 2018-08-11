//
//  FormFieldTableViewCell.swift
//  SafetyBoot
//
//  Created by Jacob Sikorski on 2017-03-20.
//  Copyright © 2017 Tamarai. All rights reserved.
//

import Foundation
import UIKit

public protocol FormFieldCellProvider {
    var tableViewCell: UITableViewCell { get }
}

open class FormFieldTableViewCell: UITableViewCell {
    
}

extension FormFieldTableViewCell: FormFieldCellProvider {
    public var tableViewCell: UITableViewCell {
        return self
    }
}
