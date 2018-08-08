//
//  UINib+Extensions.swift
//  SafetyBoot
//
//  Created by Jacob Sikorski on 2017-03-20.
//  Copyright © 2017 Tamarai. All rights reserved.
//

import Foundation
import UIKit

extension UINib {
    convenience init(name: String) {
        self.init(nibName: name, bundle: Bundle.formKit)
    }
}
