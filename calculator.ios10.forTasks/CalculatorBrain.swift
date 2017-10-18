//
//  CalculatorBrain.swift
//  calculator.ios10.forTasks
//
//  Created by Glaphi on 07/09/2017.
//  Copyright © 2017 glaphi. All rights reserved.
//

import Foundation

struct CalculatorBrain {
    
    private var stackOfOperandsAndOperations = [OperationType]()
    var variablesDictionary = [String: Double]()
    
    mutating func setOperand(_ variable: String) {
        variablesDictionary.updateValue(0.0, forKey: variable)
        stackOfOperandsAndOperations.append(.variable(variable))
    }
    
    mutating func setOperand(_ operand: Double) {
        accumulator = operand
        accumulatorWasSetFromOutside = true
        stackOfOperandsAndOperations.append(.constant(operand))
    }
    
    var result: Double? {
        get {
            return evaluate().result
        }
        set {
            result = newValue
        }
    }
    
    // Dictionary defaults to nil, variabl's value to zero.
    func evaluate(_ variables: Dictionary<String,Double>? = nil) -> (result: Double?, isPending: Bool, description: String) {
        //TODO: Fix binary operation, Pending var, then description
        
            func evaluateStack(_ stack: [OperationType]) -> (result: Double?, remainingStack: [OperationType]) {
                if !stack.isEmpty {
                    var remainingStack = stack
                    let lastEntry = remainingStack.removeLast()
                    switch lastEntry {
                    case .constant(let operand) :
                        return (operand, remainingStack)
                    case .unaryOperation(let function) :
                        let operandEvaluation = evaluateStack(remainingStack)
                        if let operand = operandEvaluation.result {
                            return (function(operand), operandEvaluation.remainingStack)
                        }
                    case .binaryOperation(let function) :
                        let firstOperandEvaluation = evaluateStack(remainingStack)
                        if let firstOperand = firstOperandEvaluation.result {
                            let secondOperandEvaluation = evaluateStack(firstOperandEvaluation.remainingStack)
                            if let secondOperand = secondOperandEvaluation.result {
                                return (function(firstOperand,secondOperand), secondOperandEvaluation.remainingStack)
                            }
                        }
                    case .variable(let variable) :
                        if variables != nil {
                            let operand = variables![variable] ?? 0.0
                            return (operand, remainingStack)
                        } // TODO: triple defualting to zero? figure this out
                        else {
                            return (0.0, remainingStack)
                        }
                    case .allClear : break
                    case .equals : break
                    case .random : break
                    case .correct : break
                    }
                }
                return (nil, stack)
            }
        let (result, _) = evaluateStack(stackOfOperandsAndOperations)
        let description = ""
        return (result, false, description)
    }
    
    /*// TODO
    mutating func performOperation(_ symbol: String) {
        if let operation = operations[symbol] {
            switch operation {
            case .constant (let value): stackOfOperandsAndOperations.append(.constant(value))
            case .unaryOperation (let function): stackOfOperandsAndOperations.append(.unaryOperation(function))
            case .binaryOperation (let function): stackOfOperandsAndOperations.append(.binaryOperation(function))
            case .equals : stackOfOperandsAndOperations.append(.equals)
            case .allClear : stackOfOperandsAndOperations.removeAll()
            case .correct :
                if stackOfOperandsAndOperations.last != nil {
                    stackOfOperandsAndOperations.removeLast()
                }
            case .random :
                let operand = Double(arc4random()) / Double(UInt32.max)
                stackOfOperandsAndOperations.append(.constant(operand))
            case .variable (let symbol) :
                stackOfOperandsAndOperations.append(.variable(symbol))
            }
        }
    }
    */
    
    // Main function performing the required action
    mutating func performOperation(_ symbol: String) {
        if let operation = operations[symbol] {
            switch operation {
            case .constant (let value):
                stackOfOperandsAndOperations.append(.constant(value))
                accumulator = value
            case .unaryOperation (let function):
                stackOfOperandsAndOperations.append(.unaryOperation(function))
                if accumulator != nil  {
                    accumulator = function(accumulator!)
                }
            case .binaryOperation (let function):
                if accumulator != nil  {
                    storedBinaryOperation = PendingBinaryOperation(function: function, firstOperand: accumulator!)
                    operationIsPending = true
                    accumulator = nil
                }
                else {
                    if storedBinaryOperation != nil {
                        storedBinaryOperation!.function = function
                        stackOfOperandsAndOperations.removeLast()
                    }
                }
                stackOfOperandsAndOperations.append(.binaryOperation(function))
            case .equals :
                stackOfOperandsAndOperations.append(.equals)
                if operationIsPending {
                    performPendingOperation()
                    operationIsPending = false
                }
            case .allClear :
                accumulator = 0
                storedBinaryOperation = nil
                operationIsPending = false
                description = " "
                accumulatorWasSetFromOutside = false
                stackOfOperandsAndOperations.removeAll()
            // Corrector: undo the last operation except for storing the value of M
            case .correct :
                if stackOfOperandsAndOperations.last != nil {
                    stackOfOperandsAndOperations.removeLast()
                }
            // Generate a random number between 0 and 1
            case .random :
                let operand = Double(arc4random()) / Double(UInt32.max)
                stackOfOperandsAndOperations.append(.constant(operand))
                accumulator = operand
            case .variable (let symbol) :
                stackOfOperandsAndOperations.append(.variable(symbol))
                accumulator = 0
            }
        }
    }
    
    // Private variables etc
    private var accumulator: Double?
    private var variableOperand: String?
    private var accumulatorWasSetFromOutside = false
    private var storedBinaryOperation: PendingBinaryOperation?
    
    // Getting the string version of accumulator in a suitable format
    private var stringAccumulator: String {
        if accumulator != nil {
            if accumulator!.remainder(dividingBy :1) == 0 {
                return String(format: "%.0f", accumulator!)
            }
            else { return String(accumulator!) }
        }
        else { return "Oh snap!" }
    }
    
    // Structure of a stored binary operation
    private struct PendingBinaryOperation {
        var function: (Double, Double) -> Double
        let firstOperand: Double
        func perform (withSecondOperand secondOperand: Double) -> Double {
            return function(firstOperand, secondOperand)
        }
    }
    
    // Short function to call the perform function out of stored operation
    private mutating func performPendingOperation () {
        if storedBinaryOperation != nil && accumulator != nil {
            accumulator = storedBinaryOperation!.perform(withSecondOperand: accumulator!)
            operationIsPending = false
        }
    }
    
    // Types of operations
    private enum OperationType {
        case constant(Double)
        case unaryOperation ((Double) -> Double)
        case binaryOperation ((Double, Double) -> Double)
        case variable(String)
        case random
        case equals
        case correct
        case allClear
    }
    
    // Dictionary of all possible operations
    private var operations: Dictionary<String, OperationType> = [
        "π" : OperationType.constant(Double.pi),
        "e" : OperationType.constant(M_E),
        "+" : OperationType.binaryOperation({$0+$1}),
        "-" : OperationType.binaryOperation({$0-$1}),
        "/" : OperationType.binaryOperation({$0/$1}),
        "x" : OperationType.binaryOperation({$0*$1}),
        "ˆ2"    : OperationType.unaryOperation({$0*$0}),
        "√"     : OperationType.unaryOperation(sqrt),
        "%"     : OperationType.unaryOperation({$0/100}),
        "±"     : OperationType.unaryOperation({-1*$0}),
        "cos"   : OperationType.unaryOperation(cos),
        "sin"   : OperationType.unaryOperation(sin),
        "=" : OperationType.equals,
        "C" : OperationType.correct,
        "AC"    : OperationType.allClear,
        "Rnd"   : OperationType.random
    ]
    
    // TODO: deprecate those
    // var (result, operationIsPending, description)  = evaluate()
    var description = ""
    var operationIsPending = false
}
