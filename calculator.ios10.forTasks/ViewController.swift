//
//  ViewController.swift
//  calculator.ios10.forTasks
//
//  Created by Glaphi on 07/09/2017.
//  Copyright © 2017 glaphi. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var userIsInTheMiddleOfTyping = false
    
/*    var displayValue: Double {
        get { return Double(display.text!)! }
        set { display.text = String(newValue) }
    }
*/
    var displayValue: Double {
        get { return Double(display.text!)! }
        set {
            if newValue.remainder(dividingBy :1) == 0{
                display.text = String(format: "%.0f", newValue)
            } else {
                display.text = String(newValue)
            }
        }
    }
    
    private var brain = CalculatorBrain()
    
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
        if userIsInTheMiddleOfTyping {
            brain.setOperand(displayValue)
            userIsInTheMiddleOfTyping = false
        }
        if let mathSymbol = sender.currentTitle {
            brain.performOperation(mathSymbol)
        }
        
        if let result = brain.result {
            displayValue = result
        }
        
    }
}


