//
//  ViewController.swift
//  Calculator
//
//  Created by Jordan Burgess on 15/02/2015.
//  Copyright (c) 2015 Jordan Burgess. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var display: UILabel!
    @IBOutlet weak var history: UILabel!
    
    var userIsInTheMiddleOfTypingNumber = false
    
    var brain = CalculatorBrain()
    
    @IBAction func appendDigit(sender: UIButton) {
        let digit = sender.currentTitle!
        
        if digit == "." && display.text!.rangeOfString(".") != nil {
            return
        }
        
        if userIsInTheMiddleOfTypingNumber {
            display.text = display.text! + digit
        } else {
            display.text = digit
            userIsInTheMiddleOfTypingNumber = true
        }
        
        history.text = history.text! + digit
        println("digit = \(digit)")
        
    }
    
    
    @IBAction func addContantToOperandStack(sender: UIButton) {
        
        if userIsInTheMiddleOfTypingNumber {
            enter()
        }
        
        let constant = sender.currentTitle!
        switch constant {
            case "π": display.text = "\(M_PI)"
            default: break
        }
        enter()
    }
    
    @IBAction func operate(sender: UIButton) {
        if userIsInTheMiddleOfTypingNumber {
            enter()
        }
        if let operation = sender.currentTitle {
            if let result = brain.performOperation(operation) {
                displayValue = result
            } else {
                displayValue = nil // :(
            }
            history.text = history.text! + operation
        }

    }
    
    @IBAction func enter() {
        userIsInTheMiddleOfTypingNumber = false
        if let result = brain.pushOperand(displayValue!) {
            displayValue = result
        } else {
            displayValue = nil //Want to set displayvalue to nil (better: error message)
        }
    }
    
    @IBAction func clearAll(sender: UIButton) {
        display.text = "\(0)"
        history.text = ""
//        operandStack = Array<Double>()
        userIsInTheMiddleOfTypingNumber = false
    }
    
    
    var displayValue: Double? {
        get {
            return NSNumberFormatter().numberFromString(display.text!)!.doubleValue
        }
        set {
            display.text = "\(newValue)"
            userIsInTheMiddleOfTypingNumber = false
        }
    }
}

