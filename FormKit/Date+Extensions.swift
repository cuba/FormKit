//
//  Date+Extensions.swift
//  SafetyBoot
//
//  Created by Jacob Sikorski on 2017-03-20.
//  Copyright © 2017 Tamarai. All rights reserved.
//


import Foundation

extension Date {
    func string(dateFormat: String) -> String? {
        return DateFormatter(dateFormat: dateFormat).string(from: self) as String?
    }
}
