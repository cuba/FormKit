//
//  SignatureField.swift
//  FormKit
//
//  Created by Jacob Sikorski on 2018-08-08.
//  Copyright © 2018 Jacob Sikorski. All rights reserved.
//

import Foundation

public struct SignatureField: FormField {
    public var key: String
    
    public init(key: String) {
        self.key = key
    }
}
