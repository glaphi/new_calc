//
//  File.swift
//  calculator.ios10.forTasks
//
//  Created by Glaphi on 19/10/2017.
//  Copyright © 2017 glaphi. All rights reserved.
//

import Foundation

/*
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
            description.dropLast()
            
        // Generate a random number between 0 and 1
        case .random :
            accumulator = Double(arc4random()) / Double(UInt32.max)
            if accumulator != nil {
                print(stringAccumulator)
            }
        }
        
    }
    
}
*/

//// Main function performing the required action
//mutating func performOperation(_ symbol: String) {
//    if let operation = operations[symbol] {
//        switch operation {
//        case .constant (let value):
//            stackOfOperandsAndOperations.append(.constant(value))
//            accumulator = value
//        case .unaryOperation (let function):
//            stackOfOperandsAndOperations.append(.unaryOperation(function))
//            if accumulator != nil  {
//                accumulator = function(accumulator!)
//            }
//        case .binaryOperation (let function):
//            if accumulator != nil  {
//                storedBinaryOperation = PendingBinaryOperation(function: function, firstOperand: accumulator!)
//                operationIsPending = true
//                accumulator = nil
//            }
//            else {
//                if storedBinaryOperation != nil {
//                    storedBinaryOperation!.function = function
//                    stackOfOperandsAndOperations.removeLast()
//                }
//            }
//            stackOfOperandsAndOperations.append(.binaryOperation(function))
//        case .equals :
//            stackOfOperandsAndOperations.append(.equals)
//            if operationIsPending {
//                performPendingOperation()
//                operationIsPending = false
//            }
//        case .allClear :
//            accumulator = 0
//            storedBinaryOperation = nil
//            operationIsPending = false
//            description = " "
//            accumulatorWasSetFromOutside = false
//            stackOfOperandsAndOperations.removeAll()
//        // Corrector: undo the last operation except for storing the value of M
//        case .correct :
//            if stackOfOperandsAndOperations.last != nil {
//                stackOfOperandsAndOperations.removeLast()
//            }
//        // Generate a random number between 0 and 1
//        case .random :
//            let operand = Double(arc4random()) / Double(UInt32.max)
//            stackOfOperandsAndOperations.append(.constant(operand))
//            accumulator = operand
//        case .variable (let symbol) :
//            stackOfOperandsAndOperations.append(.variable(symbol))
//            accumulator = 0
//        }
//    }
//}

