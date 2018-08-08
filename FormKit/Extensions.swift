//
//  Extensions.swift
//  SafetyBoot
//
//  Created by Jacob Sikorski on 2017-03-23.
//  Copyright © 2017 Tamarai. All rights reserved.
//

import Foundation

func + <K,V>(left: [K: V], right: [K: V])
    -> Dictionary<K,V> {
        var map: [K: V] = [:]
        
    for (k, v) in left {
        map[k] = v
    }
        
    for (k, v) in right {
        map[k] = v
    }
        
    return map
}
