//
//  SimpleField.swift
//  FormKit
//
//  Created by Jacob Sikorski on 2018-08-18.
//  Copyright © 2018 Jacob Sikorski. All rights reserved.
//

import Foundation
import UIKit

public struct StandardField: FormRow {
    
    private(set) public var key: String
    private(set) public var title: String
    private(set) public var subtitle: String?
    public var accessoryType: UITableViewCell.AccessoryType?
    
    public init(key: String, title: String, subtitle: String? = nil, accessoryType: UITableViewCell.AccessoryType? = nil) {
        self.key = key
        self.title = title
        self.subtitle = subtitle
        self.accessoryType = accessoryType
    }
}
