//
//  String+Extensions.swift
//  SafetyBoot
//
//  Created by Jacob Sikorski on 2017-03-20.
//  Copyright © 2017 Tamarai. All rights reserved.
//

import Foundation

extension String {
    
    func trim() -> String {
        return self.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    }
    
    func localized(_ arguments: CVarArg...) -> String {
        return String(format: NSLocalizedString(self, tableName: nil, bundle: Bundle.formKit, value: "", comment: ""), arguments: arguments)
    }
    
    static func random(length: Int = 20) -> String {
        let base = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        var randomString: String = ""
        
        for _ in 0..<length {
            let randomValue = arc4random_uniform(UInt32(base.count))
            randomString += "\(base[base.index(base.startIndex, offsetBy: Int(randomValue))])"
        }
        
        return randomString
    }
}
