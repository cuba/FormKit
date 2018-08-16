//
//  UIStyle.swift
//  FormKit
//
//  Created by Jacob Sikorski on 2017-06-10.
//  Copyright © 2017 Jacob Sikorski. All rights reserved.
//

import Foundation

public struct TextStyle {
    public var color = UIColor.black
    
    public init(color: UIColor) {
        self.color = color
    }
}

public struct BackgroundStyle {
    public var color = UIColor.white
    
    public init(color: UIColor) {
        self.color = color
    }
}

public struct ButtonStyle {
    public var text = TextStyle(color: UIColor.white)
    public var background = BackgroundStyle(color: UIColor.green)
    
    public init() {}
}

public struct PageStyle {
    public var background = BackgroundStyle(color: UIColor.groupTableViewBackground)
    
    public init() {}
}

public struct Style {
    public static var current = Style.default
    public static let `default` = Style()
    
    public var label = TextStyle(color: UIColor.black)
    public var placeholder = TextStyle(color: UIColor.lightGray)
    public var value = TextStyle(color: UIColor.darkGray)
    public var primaryButton = ButtonStyle()
    public var page = PageStyle()
    
    public init() {}
}

public extension UITextView {
    public func configure(with style: TextStyle) {
        textColor = style.color
    }
}

public extension UILabel {
    public func configure(with style: TextStyle) {
        textColor = style.color
    }
}

public extension UITextField {
    public func configure(with style: TextStyle) {
        textColor = style.color
    }
}

public extension UIButton {
    public func configure(with style: ButtonStyle) {
        setTitleColor(style.text.color, for: .normal)
        backgroundColor = style.background.color
    }
}
