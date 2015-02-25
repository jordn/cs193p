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
    
    var displayValue: Double? {
        get {
            return NSNumberFormatter().numberFromString(display.text!)!.doubleValue
        }
        set {
            if newValue != nil {
                display.text = "\(newValue!)"
            } else {
                display.text = " "
            }
            userIsInTheMiddleOfTypingNumber = false
        }
    }
    
    func updateDescription() {
        history.text = brain.description + "\n="
    }
    
    
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
        
        println("digit = \(digit)")
        
    }
    

    @IBAction func addContantToOperandStack(sender: UIButton) {
        
        if userIsInTheMiddleOfTypingNumber {
            enter()
            userIsInTheMiddleOfTypingNumber = false;
        }
        
        let constant = sender.currentTitle!
        switch constant {
        case "π":
            brain.pushOperand("π", value: M_PI)
        default: break
        }
        updateDescription()
    }
    
    @IBAction func addVariableToOperandStack(sender: UIButton) {
        if userIsInTheMiddleOfTypingNumber {
            enter()
            userIsInTheMiddleOfTypingNumber = false;
        }
        brain.pushOperand("M")
        updateDescription()
    }

    @IBAction func updateMemory(sender: UIButton) {
        userIsInTheMiddleOfTypingNumber = false;
        displayValue = brain.updateVariable("M", value: displayValue!)
        updateDescription()
    }
    
    @IBAction func operate(sender: UIButton) {
        if userIsInTheMiddleOfTypingNumber {
            enter()
        }
        if let operation = sender.currentTitle {
            let result = brain.performOperation(operation)
            displayValue = result
        }
        updateDescription();
    }
    
    @IBAction func enter() {
        if userIsInTheMiddleOfTypingNumber {
            userIsInTheMiddleOfTypingNumber = false
            if let value = displayValue {
                if let result = brain.pushOperand(value) {
                    displayValue = result
                }
            } else {
                displayValue = nil
            }
        }
        updateDescription();
    }
    
    @IBAction func clearAll(sender: UIButton) {
        display.text = " "
        history.text = " "
        brain.clear()
        userIsInTheMiddleOfTypingNumber = false
    }
    
}

