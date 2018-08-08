//
//  UIStoryboard+Extensions.swift
//  SafetyBoot
//
//  Created by Jacob Sikorski on 2017-03-20.
//  Copyright © 2017 Tamarai. All rights reserved.
//

import Foundation
import UIKit

extension UIStoryboard {
    
    convenience init(name: String) {
        self.init(name: name, bundle: Bundle.formKit)
    }
}
