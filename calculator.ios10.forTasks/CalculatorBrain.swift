//
//  CalculatorBrain.swift
//  calculator.ios10.forTasks
//
//  Created by Glaphi on 07/09/2017.
//  Copyright © 2017 glaphi. All rights reserved.
//

import Foundation

struct CalculatorBrain {
    
    private struct PendingBinaryOperation {
        let function: (Double, Double) -> Double
        let firstOperand: Double
        
        func perform (withSecondOperand secondOperand: Double) -> Double {
            return function(firstOperand, secondOperand)
        }
    }
    
    private var accumulator: Double?
    
    private var pendingBinaryOperation: PendingBinaryOperation?
    
    private var operationIsPending = false
    
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
    
    // Main function performing the required action
    mutating func performOperation(_ symbol: String) {
        if let operation = operations[symbol] {
            switch operation {
                
            case .constant (let value):
                accumulator = value
                
            case .unaryOperation (let function):
                if accumulator != nil {
                    accumulator = function(accumulator!) }
                
            case .binaryOperation (let function):
                if accumulator != nil {
                    pendingBinaryOperation = PendingBinaryOperation(function: function, firstOperand: accumulator!)
                    operationIsPending = true
                    accumulator = nil
                }
                
            case .equals :
                if operationIsPending {
                    if accumulator != nil {
                        accumulator = pendingBinaryOperation?.perform(withSecondOperand: accumulator!)
                        operationIsPending = false
                    }
                }
                
            case .allClear :
                accumulator = nil
                pendingBinaryOperation = nil
                operationIsPending = false
            }
            
        }
        
    }
    
    mutating func setOperand(_ operand: Double) {
        accumulator = operand
    }
    
    var result: Double? {
        return accumulator
    }
    
}
