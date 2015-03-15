//
//  GraphView.swift
//  Calculator
//
//  Created by Jordan Burgess on 15/03/2015.
//  Copyright (c) 2015 Jordan Burgess. All rights reserved.
//

import UIKit

protocol GraphViewDataSource: class {
    func yForX(sender: GraphView, x: CGFloat) -> CGFloat?
}

@IBDesignable
class GraphView: UIView {

    weak var dataSource: GraphViewDataSource?
    
    @IBInspectable
    var scale: CGFloat = 50.0 { didSet { setNeedsDisplay() } }
    
    @IBInspectable
    var origin: CGPoint = CGPoint() {
        didSet {
            resetOrigin = false
            setNeedsDisplay()
        }
    }
    
    @IBInspectable
    var lineWidth: CGFloat = 2 { didSet { setNeedsDisplay() } }
    
    @IBInspectable
    var color: UIColor = UIColor.blackColor() { didSet { setNeedsDisplay() } }
    
    private var resetOrigin: Bool = true {
        didSet {
            if resetOrigin {
                setNeedsDisplay()
            }
        }
    }
    
    var snapshot: UIView?
    
    
    override func drawRect(rect: CGRect) {
        println("\(contentScaleFactor)")
        
        println("\(center)")
        if resetOrigin {
            origin = center
        }
        AxesDrawer(contentScaleFactor: contentScaleFactor)
            .drawAxesInRect(bounds, origin: origin, pointsPerUnit: scale)
        
        
        color.set()
        let path = UIBezierPath()
        path.lineWidth = lineWidth
        var firstValue = true
        var point = CGPoint()
        
        for var x = 0; x <= Int(bounds.size.width * contentScaleFactor); x++ {
            point.x = CGFloat(x) / contentScaleFactor
            if let y = dataSource?.yForX(self, x: (point.x - origin.x)/scale) {
                if y.isNormal || y.isZero {
                    point.y = origin.y - y * scale
                    if firstValue {
                        path.moveToPoint(point)
                        firstValue = false
                    } else {
                        path.addLineToPoint(point)
                    }
                } else {
                    firstValue = true
                    continue
                }
            } else {
                firstValue = true
            }
        }
        path.stroke()
    }
    
    func scale(gesture: UIPinchGestureRecognizer) {
        switch gesture.state {
        case .Began:
            snapshot = snapshotViewAfterScreenUpdates(false)
            snapshot!.alpha = 0.8
            self.addSubview(snapshot!)
        case .Changed:
            let touch = gesture.locationInView(self)
            snapshot?.frame.size.height *= gesture.scale
            snapshot?.frame.size.width *= gesture.scale
            snapshot!.frame.origin.x = snapshot!.frame.origin.x * gesture.scale + (1 - gesture.scale) * touch.x
            snapshot!.frame.origin.y = snapshot!.frame.origin.y * gesture.scale + (1 - gesture.scale) * touch.y
            gesture.scale = 1
        case .Ended:
            let changedScale = snapshot!.frame.height / self.frame.height
            scale *= changedScale
            origin.x = origin.x * changedScale + snapshot!.frame.origin.x
            origin.y = origin.y * changedScale + snapshot!.frame.origin.y
            snapshot!.removeFromSuperview()

        default:
            break
        }
    }

    func pan(gesture: UIPanGestureRecognizer) {
        switch gesture.state {
        case .Began:
            snapshot = snapshotViewAfterScreenUpdates(false)
            snapshot!.alpha = 0.8
            self.addSubview(snapshot!)
        case .Changed:
            let translation = gesture.translationInView(self)
            snapshot?.center.x += translation.x
            snapshot?.center.y += translation.y
            gesture.setTranslation(CGPointZero, inView: self)
        case .Ended:
            origin.x = snapshot!.center.x
            origin.y = snapshot!.center.y
            self.alpha  = 1
            snapshot?.removeFromSuperview()
        default:
            break
        }
    }
    
    func center(gesture: UITapGestureRecognizer) {
        origin = gesture.locationInView(self)
    }

}
