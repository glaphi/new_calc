//
//  ViewController.swift
//  calculator.ios10.forTasks
//
//  Created by Glaphi on 07/09/2017.
//  Copyright © 2017 glaphi. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    private var usingVariables = false

    private var userIsInTheMiddleOfTyping = false
    
    private let formatter = NumberFormatter()
    
    var displayValue: Double {
        get { return Double(display.text!)! }
        set {
            formatter.maximumFractionDigits = 6
            formatter.minimumIntegerDigits = 1
            if newValue.remainder(dividingBy :1) == 0{
                display.text = String(format: "%.0f", newValue)
            } else {
                display.text = formatter.string(from: NSNumber(value: newValue))
            }
        }
    }
    
    private var brain = CalculatorBrain()
    
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var display: UILabel!
    
    @IBAction func touchDigit(_ sender: UIButton) {
        let digit = sender.currentTitle!
        if userIsInTheMiddleOfTyping {
            let textCurrentlyOnDisplay = display.text!
            if !(textCurrentlyOnDisplay.contains(".")) || !(digit==".") {
                display.text = textCurrentlyOnDisplay + digit
            }
        }
        else {
            if !(digit==".") {
                display.text = digit
            } else {
                display.text = "0" + digit
            }
            userIsInTheMiddleOfTyping = true
        }
    }
    
    @IBAction func performOperation(_ sender: UIButton) {
        
        if sender.currentTitle == "→M" {
            brain.variablesDictionary.updateValue(displayValue, forKey: "M")
            userIsInTheMiddleOfTyping = false
            usingVariables = true
        }
        else {
            if userIsInTheMiddleOfTyping {
                brain.setOperand(displayValue)
                if sender.currentTitle == "C" {
                    if display.text != nil {
                        let numberToCorrect = display.text!
                        display.text = String(numberToCorrect.dropLast())
                        if display.text! == "" {
                            userIsInTheMiddleOfTyping = false
                            displayValue = 0
                        }
                    }
                }
                else {
                    userIsInTheMiddleOfTyping = false
                }
            }
        }
        
        if sender.currentTitle == "AC" {
            usingVariables = false
            displayValue = 0
        }
        
        if sender.currentTitle == "M" {
            brain.setOperand("M")
        }
        
        if let mathSymbol = sender.currentTitle {
            brain.createStack(mathSymbol)
        }
        
        if usingVariables {
            if let result = brain.evaluate(brain.variablesDictionary).result {
                displayValue = result
            }
        }
        else {
            if let result = brain.evaluate().result {
                displayValue = result
            }
        }
        
        
                       if brain.operationIsPending {
                            descriptionLabel.text = brain.description + "..."
                        }
                        else {
                            if brain.description != " " {
                                descriptionLabel.text = brain.description + "="
                            }
                            else {
                                descriptionLabel.text = " "
                            }
        
                        }
    }
}


