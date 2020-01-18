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
    
    public init(color: UIColor, font: UIFont = UIFont.systemFont(ofSize: UIFont.systemFontSize)) {
        self.color = color
        self.font = font
    }
}

public struct TextFieldStyle {
    public var text: TextStyle
    
    public init(text: TextStyle) {
        self.text = text
    }
}

public struct PageStyle {
    public var backgroundColor: UIColor
    
    public init(backgroundColor: UIColor) {
        self.backgroundColor = backgroundColor
    }
}

public struct CellStyle {
    public var backgroundColor: UIColor = UIColor.white
    public var topMargin: CGFloat = 5
    public var bottomMargin: CGFloat = 5
    
    public init() {
    }
}

public struct Style {
    public static var current = Style.default
    public static let `default` = Style()
    
    public var label: TextStyle
    public var placeholder: TextStyle
    public var value: TextStyle
    public var cell = CellStyle()
    public var backgroundColor: UIColor
    
    public init() {
        if #available(iOSApplicationExtension 13.0, *) {
            label = TextStyle(color: .label, font: UIFont.systemFont(ofSize: UIFont.labelFontSize))
            placeholder = TextStyle(color: UIColor.placeholderText)
            value = TextStyle(color: UIColor.label)
            backgroundColor = UIColor.systemBackground
        } else {
            label = TextStyle(color: .black, font: UIFont.systemFont(ofSize: UIFont.labelFontSize))
            placeholder = TextStyle(color: UIColor.lightGray, font: UIFont.systemFont(ofSize: UIFont.systemFontSize))
            value = TextStyle(color: UIColor.darkGray)
            backgroundColor = UIColor.groupTableViewBackground
        }
    }
}

public extension UITextView {
    func configure(with style: TextStyle) {
        textColor = style.color
        font = style.font
    }
}

public extension UILabel {
    func configure(with style: TextStyle) {
        textColor = style.color
        font = style.font
    }
}

public extension UITextField {
    func configure(with style: TextStyle) {
        textColor = style.color
        font = style.font
    }
}

public extension UITextView {
    func configure(with style: Style) {
        font = style.value.font
        textColor = style.value.color
        
    }
}

public extension UIViewController {
    func configure(with style: Style) {
        view.backgroundColor = style.backgroundColor
    }
}
