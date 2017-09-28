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
    
    var userWantsToStartOver = false
    
    var result: Double? {
        return accumulator
    }
    
    mutating func setOperand(_ operand: Double) {
        accumulator = operand
        accumulatorWasSetFromOutside = true
        userWantsToStartOver = false
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
                accumulatorWasSetFromOutside = false
                
                
            // Unary Operation
            case .unaryOperation (let function):
                if accumulator != nil  {
                    if operationIsPending {
                        description = description + symbol + "(" +  stringAccumulator + ")"
                    }
                    else {
                        if accumulatorWasSetFromOutside {
                            description = symbol + "(" + stringAccumulator + ")"
                        }
                        else {
                            description = symbol + "(" + description + ")"
                        }
                    }
                    accumulator = function(accumulator!)
                    accumulatorWasSetFromOutside = false
                }
                
                
            // Binary Operation
            case .binaryOperation (let function):
                if accumulator != nil  {
                    if !accumulatorWasSetFromOutside {
                        description = description + symbol
                    }
                    else {
                        if operationIsPending {
                            description = "(" + description + stringAccumulator + ")" + symbol
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
                accumulatorWasSetFromOutside = false
                
            // Equals
            case .equals :
                if operationIsPending {
                    if accumulatorWasSetFromOutside {
                        description = description + stringAccumulator
                    }
                    performPendingOperation()
                    operationIsPending = false
                    accumulatorWasSetFromOutside = false
                }
                
            // Clear all
            case .allClear :
                accumulator = 0
                storedBinaryOperation = nil
                operationIsPending = false
                description = " "
                accumulatorWasSetFromOutside = false
                
            // Backspace button to correct the input
            // Find better solution than this
            case .correct :
                if accumulator != nil && accumulatorWasSetFromOutside {
                    accumulator = Double(String(stringAccumulator.characters.dropLast())) ?? 0
                }
                if accumulator == 0 {
                    userWantsToStartOver = true
                }
            }
            
        }
        
    }
    
    // Private variables etc
    
    private var accumulator: Double?
    
    // Getting the string version of accumulator in a suitable format
    private var stringAccumulator: String {
        if accumulator != nil {
            if accumulator!.remainder(dividingBy :1) == 0 {
                return String(format: "%.0f", accumulator!)
            }
            else {
                return String(accumulator!)
            }
        }
        else {
            return "Oh snap!"
        }
    }
    
    private var accumulatorWasSetFromOutside = false
    
    private var storedBinaryOperation: PendingBinaryOperation?
    
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
        case equals
        case allClear
        case correct
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
        
        "AC"    : OperationType.allClear
    ]
}
