//
//  UIStyle.swift
//  FormKit
//
//  Created by Jacob Sikorski on 2017-06-10.
//  Copyright © 2017 Jacob Sikorski. All rights reserved.
//

import Foundation

public struct TextStyle {
    var color = UIColor.black
    
    public init(color: UIColor) {
        self.color = color
    }
}

public struct BackgroundStyle {
    var color = UIColor.white
    
    public init(color: UIColor) {
        self.color = color
    }
}
public struct ButtonStyle {
    var text = TextStyle(color: UIColor.white)
    var background = BackgroundStyle(color: UIColor.green)
}

public struct Style {
    static var shared = Style.default
    static let `default` = Style()
    
    var label = TextStyle(color: UIColor.black)
    var placeholder = TextStyle(color: UIColor.lightGray)
    var value = TextStyle(color: UIColor.darkGray)
    var primaryButton = ButtonStyle()
}
