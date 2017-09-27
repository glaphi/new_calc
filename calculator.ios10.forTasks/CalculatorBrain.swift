//
//  CalculatorBrain.swift
//  calculator.ios10.forTasks
//
//  Created by Glaphi on 07/09/2017.
//  Copyright © 2017 glaphi. All rights reserved.
//

import Foundation

struct CalculatorBrain {
    
    var description = " "
    
    var operationIsPending = false
    
    var result: Double? {
        return accumulator
    }
    
    mutating func setOperand(_ operand: Double) {
        accumulator = operand
        accWasSet = true
        // accWasSet is a private variable that tells when the user typed in the new operand
        // It exists to differ this situation from when the accumulator is a result of previous computations
    }
    
    // Main function performing the required action
    mutating func performOperation(_ symbol: String) {
        
        if let operation = operations[symbol] {
            
            switch operation {
                
            // Constant
            case .constant (let value):
                accumulator = value
                if operationIsPending {
                    description = description + symbol
                }
                else {
                    description = symbol
                }
                accWasSet = false
                
                
            // Unary Operation
            case .unaryOperation (let function):
                if accumulator != nil  {
                    if operationIsPending {
                        description = description + symbol + "(" +  stringAccumulator + ")"
                    }
                    else {
                        if accWasSet {
                            description = symbol + "(" + stringAccumulator + ")"
                        }
                        else {
                            description = symbol + "(" + description + ")"
                        }
                    }
                    accumulator = function(accumulator!)
                    accWasSet = false
                }
                
                
            // Binary Operation
            case .binaryOperation (let function):
                if accumulator != nil  {
                    if !accWasSet {
                        description = description + symbol
                    }
                    else {
                        if operationIsPending {
                            description = description + stringAccumulator + symbol
                            performPendingOperation()
                        }
                        else {
                            description = stringAccumulator + symbol
                        }
                    }
                    storedBinaryOperation = PendingBinaryOperation(function: function, firstOperand: accumulator!)
                    operationIsPending = true
                    accumulator = nil
                }
                else {
                    // This is in case the user keeps pushing binary operation buttons
                    // The last one he pressed will be used in the future computations
                    if storedBinaryOperation != nil {
                        storedBinaryOperation!.function = function
                        description = String(description.characters.dropLast()) + symbol
                    }
                }
                accWasSet = false
                
            // Equals
            case .equals :
                if operationIsPending {
                    if accWasSet {
                        description = description + stringAccumulator
                    }
                    performPendingOperation()
                    operationIsPending = false
                    accWasSet = false
                }
                
            // Clear all
            case .allClear :
                accumulator = 0
                storedBinaryOperation = nil
                operationIsPending = false
                description = " "
                accWasSet = false
                
            }
            
        }
        
    }
    
    // Private variables etc
    
    private var accumulator: Double?
    
    // getting the string version of accumulator in the correct format
    private var stringAccumulator: String {
        if accumulator != nil {
            if accumulator!.remainder(dividingBy :1) == 0 {
                return String(format: "%.0f", accumulator!)
            }
            else {
                return String(format: "%.6f", accumulator!)
            }
        }
        else {
            return "Oh snap!"
        }
    }
    
    private var accWasSet = false
    
    private var storedBinaryOperation: PendingBinaryOperation?

    private struct PendingBinaryOperation {
        var function: (Double, Double) -> Double
        let firstOperand: Double
        
        func perform (withSecondOperand secondOperand: Double) -> Double {
            return function(firstOperand, secondOperand)
        }
    }
    
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
        case equals
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
        
        "AC"    : OperationType.allClear
    ]
}
