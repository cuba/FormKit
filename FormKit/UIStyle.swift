//
//  UIStyle.swift
//  FormKit
//
//  Created by Jacob Sikorski on 2017-06-10.
//  Copyright © 2017 Jacob Sikorski. All rights reserved.
//

import Foundation

public struct TextStyle {
    public var color: UIColor
    public var font: UIFont
    
    public init(color: UIColor, font: UIFont) {
        self.color = color
        self.font = font
    }
}

public struct ButtonStyle {
    public var text: TextStyle
    public var backgroundColor: UIColor
    
    init(text: TextStyle, backgroundColor: UIColor) {
        self.text = text
        self.backgroundColor = backgroundColor
    }
}

public struct TextViewStyle {
    public var text: TextStyle
    public var backgroundColor: UIColor
    
    init(text: TextStyle, backgroundColor: UIColor) {
        self.text = text
        self.backgroundColor = backgroundColor
    }
}

public struct TextFieldStyle {
    public var text: TextStyle
    
    init(text: TextStyle) {
        self.text = text
    }
}

public struct PageStyle {
    public var backgroundColor: UIColor
    
    public init(backgroundColor: UIColor) {
        self.backgroundColor = backgroundColor
    }
}

public struct Style {
    public static var current = Style.default
    public static let `default` = Style()
    
    public var label = TextStyle(color: UIColor.black, font: UIFont.systemFont(ofSize: 16, weight: .medium))
    public var placeholder = TextStyle(color: UIColor.lightGray, font: UIFont.systemFont(ofSize: 14))
    public var value = TextStyle(color: UIColor.darkGray, font: UIFont.systemFont(ofSize: 14))
    public var textArea = TextViewStyle(text: TextStyle(color: UIColor.darkGray, font: UIFont.systemFont(ofSize: 14)), backgroundColor: UIColor.white)
    public var primaryButton = ButtonStyle(text: TextStyle(color: UIColor.white, font: UIFont.systemFont(ofSize: 16, weight: .medium)), backgroundColor: UIColor.green)
    public var page = PageStyle(backgroundColor: UIColor.groupTableViewBackground)
    
    public init() {}
}

public extension UITextView {
    public func configure(with style: TextStyle) {
        textColor = style.color
        font = style.font
    }
}

public extension UILabel {
    public func configure(with style: TextStyle) {
        textColor = style.color
        font = style.font
    }
}

public extension UITextField {
    public func configure(with style: TextStyle) {
        textColor = style.color
        font = style.font
    }
}

public extension UIButton {
    public func configure(with buttonStyle: ButtonStyle) {
        setTitleColor(buttonStyle.text.color, for: .normal)
        titleLabel?.font = buttonStyle.text.font
        backgroundColor = buttonStyle.backgroundColor
    }
}

public extension UITextView {
    public func configure(with textViewStyle: TextViewStyle) {
        backgroundColor = textViewStyle.backgroundColor
        font = textViewStyle.text.font
        textColor = textViewStyle.text.color
    }
}

public extension UIViewController {
    public func configure(with pageStyle: PageStyle) {
        view.backgroundColor = pageStyle.backgroundColor
    }
}
