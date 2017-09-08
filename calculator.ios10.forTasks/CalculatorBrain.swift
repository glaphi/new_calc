//
//  CalculatorBrain.swift
//  calculator.ios10.forTasks
//
//  Created by Glaphi on 07/09/2017.
//  Copyright © 2017 glaphi. All rights reserved.
//

import Foundation

struct CalculatorBrain {
    
    private var accumulator: Double?
    
    private enum OperationType {
        case constant(Double)
        case unaryOperation ((Double) -> Double)
        case binaryOperation ((Double, Double) -> Double)
        case equals
        case allClear
    }
    
    private var operations: Dictionary<String, OperationType> = [
        "π" : OperationType.constant(Double.pi),
        "e" : OperationType.constant(M_E),
        "+" : OperationType.binaryOperation({$0+$1}),
        "-" : OperationType.binaryOperation({$0-$1}),
        "/" : OperationType.binaryOperation({$0/$1}),
        "x" : OperationType.binaryOperation({$0*$1}),
        "ˆ2"    : OperationType.unaryOperation({$0*$0}),
        "√" : OperationType.unaryOperation(sqrt),
        "%" : OperationType.unaryOperation({$0/100}),
        "±" : OperationType.unaryOperation({-1*$0}),
        "cos"   : OperationType.unaryOperation(cos),
        "sin"   : OperationType.unaryOperation(sin),
        "=" : OperationType.equals,
        "AC"    : OperationType.allClear
        
    ]
    
    func performOperation(_ symbol: String) {
    
        
    }
    
    mutating func setOperand(_ operand: Double) {
        accumulator = operand
    }
    
    var result: Double? {
        return accumulator
    }

}
