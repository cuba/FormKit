//
//  Bundle+Extensions.swift
//  SafetyBoot
//
//  Created by Jacob Sikorski on 2017-03-20.
//  Copyright © 2017 Tamarai. All rights reserved.
//

import Foundation

extension Bundle {
    open static var formKit: Bundle {
        return Bundle(identifier: "com.pineapplepush.FormKit")!
    }
    
    var version: String? {
        return infoDictionary?["CFBundleShortVersionString"] as? String
    }
}
