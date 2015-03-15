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
                    point.y = origin.y - y * scale // CGFloat(y) / contentScaleFactor
                    if firstValue {
                        path.moveToPoint(point)
                        firstValue = false
                    } else {
                        path.addLineToPoint(point)
                    }
                }
            }
        }
        path.stroke()
    }
    

}
