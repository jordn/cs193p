//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by Jordan Burgess on 16/02/2015.
//  Copyright (c) 2015 Jordan Burgess. All rights reserved.
//

import Foundation

class CalculatorBrain {
    
    private enum Op: Printable {
        case Operand(Double)
        case Constant(String, Double)
        case Variable(String)
        case UnaryOperation(String, Double -> Double)
        case BinaryOperation(String, (Double, Double) -> Double)
        
        var description: String {
            get {
                switch self {
                case .Operand(let operand):
                    return "\(operand)"
                case .Constant(let symbol, _):
                    return symbol
                case .Variable(let symbol):
                    return symbol
                case .UnaryOperation(let symbol, _):
                    return symbol
                case .BinaryOperation(let symbol, _):
                    return symbol
                }
            }
        }
    }
    private var opStack = [Op]()
    private var knownOps = [String:Op]()
    private var variableValues = [String:Double]()
    
    var description: String {
        get {
            var fullDescription = ""
            var (expression, remainder) = describe(opStack)
            fullDescription += expression!
            while !remainder.isEmpty {
                (expression, remainder) = describe(remainder)
                println("\(expression) \(remainder)")
                fullDescription = expression! + ", " + fullDescription
            }
            return fullDescription
        }
    }
    
    private func describe(ops: [Op]) -> (result: String?, remainingOps: [Op]) {
        if !ops.isEmpty {
            var remainingOps = ops
            let op = remainingOps.removeLast()
            println("op: \(op)")
            switch op {
            case .Operand(let operand):
                return ("\(operand)", remainingOps)
            case .Constant(let symbol, _):
                return (symbol, remainingOps)
            case .Variable(let variable):
                return (variable, remainingOps)
            case .UnaryOperation(let symbol, _):
                let (inside, remaining) = describe(remainingOps)
                return ("\(symbol)(\(inside!))", remaining)
            case .BinaryOperation(let symbol, _):
                let op1Description = describe(remainingOps)
                if let operand1 = op1Description.result {
                    let op2Description = describe(op1Description.remainingOps)
                    if let operand2 = op2Description.result {
                        if symbol == "−" || symbol == "+" {
                            return ("(\(operand2) \(symbol) \(operand1))", op2Description.remainingOps)
                        } else {
                            return ("\(operand2) \(symbol) \(operand1)", op2Description.remainingOps)
                        }
                    }
                }
                return ("binary fail", remainingOps)
            }
        } else  {
            return ("?", [])
        }
    }
    
    init() {
        func learnOp(op: Op) {
            knownOps[op.description] = op
        }
        learnOp(Op.BinaryOperation("×", *))
        learnOp(Op.BinaryOperation("+", +))
        learnOp(Op.BinaryOperation("−") { $1 - $0 })
        learnOp(Op.BinaryOperation("÷") { $1 / $0 })
        learnOp(Op.UnaryOperation("√", sqrt ))
        learnOp(Op.UnaryOperation("sin", sin ))
        learnOp(Op.UnaryOperation("cos", sin ))
    }
    
    typealias PropertyList = AnyObject
    var program: PropertyList { // guaranteed to be a property list
        get {
            return opStack.map{ $0.description }
        }
        set {
            if let opSymbols = newValue as? Array<String> {
                var newOpStack = [Op]()
                let numberFormatter = NSNumberFormatter()
                for opSymbol in opSymbols {
                    if let op = knownOps[opSymbol] {
                        newOpStack.append(op)
                    } else if let operand = numberFormatter.numberFromString(opSymbol)?.doubleValue {
                        newOpStack.append(.Operand(operand))
                    } else {
                        newOpStack.append(.Variable(opSymbol))
                    }
                }
                opStack = newOpStack
            }
        }
    }
    
    func clear() {
        opStack = []
        variableValues = [:]
    }
    
    func pushOperand(operand: Double) -> Double? {
        opStack.append(Op.Operand(operand))
        return evaluate()
    }
    
    func pushOperand(symbol: String, value: Double) -> Double? {
        opStack.append(Op.Constant(symbol, value))
        return evaluate()
    }

    func pushOperand(symbol: String) -> Double? {
        opStack.append(Op.Variable(symbol))
        return evaluate()
    }
    
    func updateVariable(variable: String, value: Double) -> Double? {
        self.variableValues[variable] = value
        return evaluate()
    }
    
    func performOperation(symbol: String) -> Double? {
        if let operation = knownOps[symbol] {
            opStack.append(operation)
        }
        return evaluate()
    }
    
    private func evaluate(ops: [Op]) -> (result: Double?, remainingOps: [Op]) {
        if !ops.isEmpty {
            var remainingOps = ops
            let op = remainingOps.removeLast()
            switch op {
            case .Operand(let operand):
                return (operand, remainingOps)
            case .Constant(_, let value):
                return (value, remainingOps)
            case .Variable(let variable):
                if let value = self.variableValues[variable] {
                    return (value, remainingOps)
                } else {
                    return (nil, remainingOps)
                }
            case .UnaryOperation(_, let operation):
                let operandEvaluation = evaluate(remainingOps)
                if let operand = operandEvaluation.result {
                    return (operation(operand), operandEvaluation.remainingOps)
                }
            case .BinaryOperation(_, let operation):
                let op1Evaluation = evaluate(remainingOps)
                if let operand1 = op1Evaluation.result {
                    let op2Evaluation = evaluate(op1Evaluation.remainingOps)
                    if let operand2 = op2Evaluation.result {
                        return (operation(operand1, operand2), op2Evaluation.remainingOps)
                    }
                }
            }
        }
        return (nil, ops)
    }
    
    func evaluate() -> Double? {
        let (result, remainder) = evaluate(opStack)
        println("\(opStack) = \(result) with \(remainder) left over")
        return result
    }
}