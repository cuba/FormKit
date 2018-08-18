//
//  SignatureView.swift
//  FormKit
//
//  Created by Jacob Sikorski on 2018-08-11.
//  Copyright © 2018 Jacob Sikorski. All rights reserved.
//

import UIKit

public protocol SignatureViewDelegate: class {
    func signatureViewDidTapInside(_ view: SignatureView)
    func signatureViewDidPanInside(_ view: SignatureView)
}

open class SignatureView: UIView {
    open weak var delegate: SignatureViewDelegate?
    
    /**
     The the maximum stroke width should be a 1 or greater. The largest line width will be determined by this value.
     */
    open var maximumStrokeWidth: CGFloat = 2 {
        didSet {
            if(maximumStrokeWidth < minimumStrokeWidth || maximumStrokeWidth <= 0) {
                maximumStrokeWidth = oldValue
            }
        }
    }
    
    /**
     The the minimum stroke width should be a 1 or greater. The smallest line width will be determined by this value. Default is
     */
    open var minimumStrokeWidth: CGFloat = 1 {
        didSet {
            if(minimumStrokeWidth > maximumStrokeWidth || minimumStrokeWidth <= 0) {
                minimumStrokeWidth = oldValue
            }
        }
    }
    
    /**
     The fudge factor should be a value between 0 and 100. Any value closer to 0 means that you have to move your finger slower to get a thick line.
     0 means that the minimum stroke is always applied. 100 means the maximum stroke is always applied. Default is 20.
    */
    var fudgeFactor: CGFloat = 20
    
    /**
     The the color of the signature (pen ink) used. Default is black.
     */
    open var strokeColor: UIColor = UIColor.black
    
    /**
     The stroke alpha. Prefer higher values to prevent stroke segments from showing through.
     */
    open var strokeAlpha: CGFloat = 1.0 {
        didSet {
            if(strokeAlpha <= 0.0 || strokeAlpha > 1.0) {
                strokeAlpha = oldValue
            }
        }
    }
    
    /**
     The UIImage representation of the signature. Read only.
     */
    private(set) open var signature: UIImage?
    
    // MARK: Public Methods
    open func clear() {
        signature = nil
        self.setNeedsDisplay()
    }
    
    // MARK: Private Methods
    private var xRange: ClosedRange<CGFloat>?
    private var yRange: ClosedRange<CGFloat>?
    private var previousPoint = CGPoint.zero
    private var previousEndPoint = CGPoint.zero
    private var previousWidth:CGFloat = 0.0
    
    open var croppedSignature: UIImage? {
        guard let signature = self.signature else { return nil }
        return cropImage(image: signature, in: drawFrame)
    }
    
    private var drawFrame: CGRect {
        guard let xRange = self.xRange, let yRange = self.yRange else { return CGRect.zero }
        let origin = CGPoint(x: max(0, xRange.lowerBound - 10), y: max(0, yRange.lowerBound - 10))
        let size = CGSize(width: min(xRange.upperBound, bounds.size.width), height: min(yRange.upperBound, bounds.size.height))
        return CGRect(origin: origin, size: size)
    }
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        setupGestureRecognizers()
        backgroundColor = UIColor.clear
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupGestureRecognizers() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapGesture(_:)))
        self.addGestureRecognizer(tapGestureRecognizer)
        
        let panGestorRecognizer = UIPanGestureRecognizer(target: self, action: #selector(panGesture(_:)))
        panGestorRecognizer.minimumNumberOfTouches = 1
        panGestorRecognizer.maximumNumberOfTouches = 1
        self.addGestureRecognizer(panGestorRecognizer)
    }
    
    @objc private func tapGesture(_ tap: UITapGestureRecognizer) {
        let rect = self.bounds
        let point = tap.location(in: self)
        setRanges(from: point)
        
        UIGraphicsBeginImageContextWithOptions(rect.size, false, UIScreen.main.scale)
        
        if signature == nil {
            signature = UIGraphicsGetImageFromCurrentImageContext()
        }
        
        signature?.draw(in: rect)
        let currentPoint = point
        drawPointAt(currentPoint, pointSize: 5.0)
        signature = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        self.setNeedsDisplay()
        
        self.delegate?.signatureViewDidTapInside(self)
    }
    
    @objc private func panGesture(_ pan: UIPanGestureRecognizer) {
        let point = pan.location(in: self)
        setRanges(from: point)
        
        switch(pan.state) {
        case .began:
            previousPoint = point
            previousEndPoint = previousPoint
        case .changed:
            let currentPoint = point
            let strokeLength = distance(previousPoint, pt2: currentPoint)
            
            if strokeLength >= 1.0 {
                let rect = self.bounds
                UIGraphicsBeginImageContextWithOptions(rect.size, false, UIScreen.main.scale)
                
                if signature == nil {
                    signature = UIGraphicsGetImageFromCurrentImageContext()
                }
                
                // Draw the prior signature
                signature?.draw(in: rect)
                
                let delta: CGFloat = 0.5
                let currentWidth = max(minimumStrokeWidth, min(maximumStrokeWidth, 1/strokeLength * fudgeFactor * delta + previousWidth * (1 - delta)))
                let midPoint = CGPointMid(p0:currentPoint, p1:previousPoint)
                
                drawQuadCurve(previousEndPoint, control: previousPoint, end: midPoint, startWidth:previousWidth, endWidth: currentWidth)
                
                signature = UIGraphicsGetImageFromCurrentImageContext()
                UIGraphicsEndImageContext()
                previousPoint = currentPoint
                previousEndPoint = midPoint
                previousWidth = currentWidth
                self.setNeedsDisplay()
            }
            
        default:
            break
        }
        
        self.delegate?.signatureViewDidPanInside(self)
    }
    
    private func setRanges(from point: CGPoint) {
        if let xRange = self.xRange {
            self.xRange = min(xRange.lowerBound, point.x)...max(xRange.upperBound, point.x)
        } else {
            self.xRange = point.x...point.x
        }
        
        if let yRange = self.yRange {
            self.yRange = min(yRange.lowerBound, point.y)...max(yRange.upperBound, point.y)
        } else {
            self.yRange = point.y...point.y
        }
    }
    
    private func distance(_ pt1: CGPoint, pt2: CGPoint) -> CGFloat {
        return sqrt((pt1.x - pt2.x)*(pt1.x - pt2.x) + (pt1.y - pt2.y)*(pt1.y - pt2.y))
    }
    
    private func CGPointMid(p0: CGPoint, p1: CGPoint) -> CGPoint {
        return CGPoint(x: (p0.x+p1.x)/2.0, y: (p0.y+p1.y)/2.0)
    }
    
    override open func draw(_ rect: CGRect) {
        signature?.draw(in: rect)
    }
    
    private func getOffsetPoints(p0: CGPoint, p1: CGPoint, width: CGFloat) -> (p0: CGPoint, p1: CGPoint) {
        let pi_by_2:CGFloat = 3.14/2
        let delta = width/2.0
        let v0 = p1.x - p0.x
        let v1 = p1.y - p0.y
        let divisor = sqrt(v0*v0 + v1*v1)
        let u0 = v0/divisor
        let u1 = v1/divisor
        
        // rotate vector
        let ru0 = cos(pi_by_2)*u0 - sin(pi_by_2)*u1
        let ru1 = sin(pi_by_2)*u0 + cos(pi_by_2)*u1
        
        // scale the vector
        let du0 = delta * ru0
        let du1 = delta * ru1
        
        return (CGPoint(x: p0.x + du0, y: p0.y + du1), CGPoint(x: p0.x - du0, y: p0.y - du1))
    }
    
    private func drawQuadCurve(_ start: CGPoint, control: CGPoint, end: CGPoint, startWidth: CGFloat, endWidth: CGFloat) {
        guard start != control else { return }
        
        let path = UIBezierPath()
        let controlWidth = (startWidth+endWidth)/2.0
        
        let startOffsets = getOffsetPoints(p0: start, p1: control, width: startWidth)
        let controlOffsets = getOffsetPoints(p0: control, p1: start, width: controlWidth)
        let endOffsets = getOffsetPoints(p0: end, p1: control, width: endWidth)
        
        path.move(to: startOffsets.p0)
        path.addQuadCurve(to: endOffsets.p1, controlPoint: controlOffsets.p1)
        path.addLine(to: endOffsets.p0)
        path.addQuadCurve(to: startOffsets.p1, controlPoint: controlOffsets.p0)
        path.addLine(to: startOffsets.p1)
        
        let signatureColor = strokeColor.withAlphaComponent(strokeAlpha)
        signatureColor.setFill()
        signatureColor.setStroke()
        
        path.lineWidth = 1
        path.lineJoinStyle = CGLineJoin.round
        path.lineCapStyle = CGLineCap.round
        path.stroke()
        path.fill()
    }
    
    private func drawPointAt(_ point: CGPoint, pointSize: CGFloat = 1.0) {
        let path = UIBezierPath()
        let signatureColor = strokeColor.withAlphaComponent(strokeAlpha)
        signatureColor.setStroke()
        
        path.lineWidth = pointSize
        path.lineCapStyle = CGLineCap.round
        path.move(to: point)
        path.addLine(to: point)
        path.stroke()
    }
    
    private func cropImage(image: UIImage, in cropRect: CGRect) -> UIImage? {
        print("draw frame size: \(drawFrame.size)")
        print("image size: \(image.size)")
        
        UIGraphicsBeginImageContextWithOptions(bounds.size, false, 0)
        let context = UIGraphicsGetCurrentContext()
        
        context?.translateBy(x: 0.0, y: image.size.height)
        context?.scaleBy(x: 1.0, y: -1.0)
        context?.draw(image.cgImage!, in: CGRect(x:0, y:0, width:image.size.width, height:image.size.height), byTiling: false)
        context?.clip(to: [bounds])
        
        let croppedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return croppedImage
    }
}
