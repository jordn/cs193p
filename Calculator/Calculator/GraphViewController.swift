//
//  GraphViewController.swift
//  Calculator
//
//  Created by Jordan Burgess on 12/03/2015.
//  Copyright (c) 2015 Jordan Burgess. All rights reserved.
//

import UIKit

class GraphViewController: UIViewController, GraphViewDataSource {
    
    func yForX(view: GraphView, x: CGFloat) -> CGFloat? {
        brain.updateVariable("M", value: Double(x))
        if let y = brain.evaluate() {
            return CGFloat(y)
        }
        return nil
    }
    
    private var brain = CalculatorBrain()
    
    typealias PropertyList = AnyObject
    var program: AnyObject {
        get {
            return brain.program
        }
        set {
            brain.program = newValue
        }
    }
    
    
    @IBOutlet weak var graphView: GraphView! {
        didSet {
            graphView.dataSource = self
            graphView.addGestureRecognizer(UIPinchGestureRecognizer(target: graphView, action: "scale:"))
            graphView.addGestureRecognizer(UIPanGestureRecognizer(target: graphView, action: "pan:"))
            let tap = UITapGestureRecognizer(target: graphView, action: "center:")
            tap.numberOfTapsRequired = 2
            graphView.addGestureRecognizer(tap)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
}
