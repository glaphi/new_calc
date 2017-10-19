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
        stackOfOperandsAndOperations.append(.variable(variable))
        print (variable)
    }
    
    mutating func setOperand(_ operand: Double) {
        stackOfOperandsAndOperations.append(.constant(operand))
    }
    
    // Dictionary defaults to nil, variabl's value to zero.
    func evaluate(_ variables: Dictionary<String,Double>? = nil) -> (result: Double?, isPending: Bool, description: String) {
        //TODO: Pending var, then description
        
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
                        let secondOperandEvaluation = evaluateStack(remainingStack)
                        if let secondOperand = secondOperandEvaluation.result {
                            let firstOperandEvaluation = evaluateStack(secondOperandEvaluation.remainingStack)
                            if let firstOperand = firstOperandEvaluation.result {
                                return (function(firstOperand,secondOperand), firstOperandEvaluation.remainingStack)
                            }
                        }
                    case .variable(let variable) :
                        if variables != nil {
                            for (key, value) in variables! {
                                if variable == key {
                                let operand = value
                                return (operand, remainingStack)
                                }
                            }
                        }
                         // TODO: triple defualting to zero? figure this out
                        else {
                            return (666, remainingStack)
                        }
                    case .allClear : return (nil, [])
                    case .equals : return evaluateStack(remainingStack)
                    default : break
                    }
                }
                return (nil, stack)
            }
        let (result, _) = evaluateStack(stackOfOperandsAndOperations)
        let description = ""
        return (result, false, description)
    }
    
    
    // main function to create
    mutating func createStack(_ symbol: String) {
        if let operation = operations[symbol] {
            switch operation {
            case .constant (let value):
                userKeepsPresingBinaryOperations = false
                stackOfOperandsAndOperations.append(.constant(value))
            case .unaryOperation (let function):
                userKeepsPresingBinaryOperations = false
                stackOfOperandsAndOperations.append(.unaryOperation(function))
            case .binaryOperation (let function):
                if (userKeepsPresingBinaryOperations == false) && (storedOperation != nil) {
                    stackOfOperandsAndOperations.append(storedOperation!)
                }
                storedOperation = .binaryOperation(function)
                userKeepsPresingBinaryOperations = true
            case .equals :
                if storedOperation != nil {
                    stackOfOperandsAndOperations.append(storedOperation!)
                    storedOperation = nil
                }
                stackOfOperandsAndOperations.append(.equals)
                userKeepsPresingBinaryOperations = false
            case .allClear :
                stackOfOperandsAndOperations.removeAll()
                userKeepsPresingBinaryOperations = false
            case .correct :
                userKeepsPresingBinaryOperations = false
                if stackOfOperandsAndOperations.last != nil {
                    stackOfOperandsAndOperations.removeLast()
                }
            case .random :
                userKeepsPresingBinaryOperations = false
                let operand = Double(arc4random()) / Double(UInt32.max)
                stackOfOperandsAndOperations.append(.constant(operand))
            case .variable (let symbol) :
                userKeepsPresingBinaryOperations = false
                stackOfOperandsAndOperations.append(.variable(symbol))
            }
        }
    }
 
    // Private variables etc
    private var variableOperand: String?
    private var storedOperation: OperationType?
    private var userKeepsPresingBinaryOperations = false
    
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
}
