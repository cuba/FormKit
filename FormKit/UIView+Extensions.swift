//
//  UIView+Extensions.swift
//  SafetyBoot
//
//  Created by Jacob Sikorski on 2017-03-22.
//  Copyright © 2017 Tamarai. All rights reserved.
//

import UIKit

extension UIView {
    func round() {
        let width = self.layer.frame.width
        let height = self.layer.frame.height
        let radius = min(width, height)
        self.round(radius: radius/2)
    }
    
    func round(radius: CGFloat) {
        self.layer.cornerRadius = radius
    }
    
    func border(color: CGColor, size: CGFloat) {
        self.layer.borderWidth = size
        self.layer.borderColor = color
    }
    
    func shadow(color: CGColor, offset: CGSize, opacity: Float, radius: CGFloat) {
        self.layer.shadowOffset = offset
        self.layer.shadowColor = color
        self.layer.shadowOpacity = opacity
        self.layer.shadowRadius = radius
    }
    
    func borderBottom(color: CGColor, size: CGFloat) {
        let border = CALayer()
        border.borderColor = color
        border.frame = CGRect(x: 0, y: self.frame.size.height - size, width:  self.frame.size.width, height: self.frame.size.height)
        
        border.borderWidth = size
        self.layer.addSublayer(border)
        self.layer.masksToBounds = true
    }
    
    func applyGradient(colours: [UIColor]) -> Void {
        self.applyGradient(colours: colours, locations: nil)
    }
    
    func applyGradient(colours: [UIColor], locations: [NSNumber]?) -> Void {
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = self.bounds
        gradient.colors = colours.map { $0.cgColor }
        gradient.locations = locations
        self.layer.insertSublayer(gradient, at: 0)
    }
}
