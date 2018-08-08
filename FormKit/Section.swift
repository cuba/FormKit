//
//  FormSection.swift
//  SafetyBoot
//
//  Created by Jacob Sikorski on 2017-03-24.
//  Copyright © 2017 Tamarai. All rights reserved.
//

import Foundation

public struct FormSection {
    public var title: String?
    public var fields: [FormField] = []
    
    public init(title: String? = nil, fields: [FormField]) {
        self.title = title
        self.fields = fields
    }
}
