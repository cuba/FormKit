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

public struct ButtonStyle {
    public var text: TextStyle
    public var backgroundColor: UIColor
    
    public init(text: TextStyle, backgroundColor: UIColor) {
        self.text = text
        self.backgroundColor = backgroundColor
    }
}

public struct TextViewStyle {
    public var text: TextStyle
    public var backgroundColor: UIColor
    
    public init(text: TextStyle, backgroundColor: UIColor) {
        self.text = text
        self.backgroundColor = backgroundColor
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
    
    public var backgroundColor: UIColor
    public var secondaryBackgroundColor: UIColor
    public var groupedBackgroundColor: UIColor
    
    public var label: TextStyle
    public var placeholder: TextStyle
    public var value: TextStyle
    public var textArea: TextViewStyle
    public var cell = CellStyle()
    
    public init() {
        if #available(iOSApplicationExtension 13.0, *) {
            label = TextStyle(color: .label, font: UIFont.systemFont(ofSize: UIFont.labelFontSize))
            placeholder = TextStyle(color: UIColor.placeholderText)
            value = TextStyle(color: UIColor.label)
            textArea = TextViewStyle(text: TextStyle(color: UIColor.label), backgroundColor: UIColor.systemBackground)
            
            backgroundColor = UIColor.systemBackground
            secondaryBackgroundColor = UIColor.secondarySystemBackground
            groupedBackgroundColor = UIColor.systemGroupedBackground
        } else {
            label = TextStyle(color: .black, font: UIFont.systemFont(ofSize: UIFont.labelFontSize))
            placeholder = TextStyle(color: UIColor.lightGray, font: UIFont.systemFont(ofSize: UIFont.systemFontSize))
            value = TextStyle(color: UIColor.darkGray)
            textArea = TextViewStyle(text: TextStyle(color: UIColor.darkGray), backgroundColor: UIColor.white)
            
            backgroundColor = UIColor.white
            secondaryBackgroundColor = UIColor.groupTableViewBackground
            groupedBackgroundColor = UIColor.groupTableViewBackground
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

public extension UIButton {
    func configure(with buttonStyle: ButtonStyle) {
        setTitleColor(buttonStyle.text.color, for: .normal)
        titleLabel?.font = buttonStyle.text.font
        backgroundColor = buttonStyle.backgroundColor
    }
}

public extension UITextView {
    func configure(with style: Style) {
        backgroundColor = style.backgroundColor
        font = style.value.font
        textColor = style.value.color
    }
}

public extension UIViewController {
    func configure(with style: Style) {
        view.backgroundColor = style.backgroundColor
    }
}
