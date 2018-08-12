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
    
    init() {}
}

public struct PageStyle {
    var background = BackgroundStyle(color: UIColor.groupTableViewBackground)
    
    init() {}
}

public struct Style {
    static var current = Style.default
    static let `default` = Style()
    
    var label = TextStyle(color: UIColor.black)
    var placeholder = TextStyle(color: UIColor.lightGray)
    var value = TextStyle(color: UIColor.darkGray)
    var primaryButton = ButtonStyle()
    var page = PageStyle()
}

extension UITextView {
    func configure(with style: TextStyle) {
        textColor = style.color
    }
}

extension UILabel {
    func configure(with style: TextStyle) {
        textColor = style.color
    }
}

extension UITextField {
    func configure(with style: TextStyle) {
        textColor = style.color
    }
}

extension UIButton {
    func configure(with style: ButtonStyle) {
        setTitleColor(style.text.color, for: .normal)
        backgroundColor = style.background.color
    }
}
