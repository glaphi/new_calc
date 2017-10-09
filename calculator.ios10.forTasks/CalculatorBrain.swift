//
//  CalculatorBrain.swift
//  calculator.ios10.forTasks
//
//  Created by Glaphi on 07/09/2017.
//  Copyright © 2017 glaphi. All rights reserved.
//

import Foundation

struct CalculatorBrain {
    
    var userWantsToStartOver = false
    
    mutating func setOperand(variable letter: String) {
        variableOperand = letter
        variablesDictionary.updateValue(0.0, forKey: letter)
        sequenceOfOperandsAndOperations.append(variableOperand!)
    }
    
    // Function that substituting values for variables
    // Those values are found in a Dictionary
    // Dictionary defaults to nil if not supplied when this method is called
    // If a variable is not found in the Variables Dictionary, its value is zero by default.
 func evaluate(_ variables: Dictionary<String,Double>? = nil)
        -> (result: Double?, isPending: Bool, description: String) {
            let result = 0.0
            let isPending = false
            let description = ""
            return (result, isPending, description)
    }
    
    // The old result, description and resultIsPending vars will be implemented
    // By calling evaluate with the argument nil
    // (i.e. they will give their answer assuming the value of any variables is zero).
    
    
    // Main function performing the required action
    mutating func performOperation(_ symbol: String) {
        
        if let operation = operations[symbol] {
            
            sequenceOfOperandsAndOperations.append(symbol)
            print(sequenceOfOperandsAndOperations)
            
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
                result = accumulator
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
                    result = accumulator
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
                            result = accumulator
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
                    result = accumulator
                    operationIsPending = false
                    accumulatorWasSetFromOutside = false
                }
                
            // Clear all
            case .allClear :
                accumulator = 0
                result = 0
                storedBinaryOperation = nil
                operationIsPending = false
                description = " "
                accumulatorWasSetFromOutside = false
                sequenceOfOperandsAndOperations.removeAll()
                
                // Backspace button to correct the input
            // Find better solution than this
            case .correct :
                if accumulator != nil && accumulatorWasSetFromOutside {
                    accumulator = Double(String(stringAccumulator.characters.dropLast())) ?? 0
                }
                if accumulator == 0 {
                    userWantsToStartOver = true
                }
                
            // Generate a random number between 0 and 1
            case .random :
                accumulator = Double(arc4random()) / Double(UInt32.max)
                if accumulator != nil {
                    print(stringAccumulator)
                }
            }
            
        }
        
    }
    
    // Private variables etc
    
    private var accumulator: Double?
    
    private var variableOperand: String?
    
    private var accumulatorWasSetFromOutside = false
    
    private var storedBinaryOperation: PendingBinaryOperation?
    
    private var sequenceOfOperandsAndOperations = ""
    
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
            // This should never happened
            return "Oh snap!"
        }
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
        case equals
        case allClear
        case correct
        case random
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
    
    // Old result, description and resultIsPending
    // Trying to deprecate those
    
    var description = ""
    // var description = { return evaluate().description }
    
    var result: Double!
    // var result = { return evaluate().result }

    var operationIsPending = false 
    // var operationIsPending = { return evaluate().isPending }
    
    mutating func setOperand(_ operand: Double) {
        accumulator = operand
        accumulatorWasSetFromOutside = true
        userWantsToStartOver = false
        sequenceOfOperandsAndOperations.append(stringAccumulator)
        // accumulatorWasSetFromOutside is a private variable that tells when the user typed in the new operand
        // It exists to differ this situation from when the accumulator is a result of previous computations
    }
    var variablesDictionary: [String: Double] = [:]
}


// Model is not just a CalculatorBrain anymore. There are 2 different
// and completely separate structs: a CalculatorBrain and a Dictionary.
// (the one that contains M’s value).
// There’s no rule that says a Model has to be a single data structure.

