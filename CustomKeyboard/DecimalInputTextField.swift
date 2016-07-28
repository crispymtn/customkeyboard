//
//  DecimalInputTextField.swift
//  Test
//
//  Created by Joachim Garth on 20/04/16.
//  Copyright © 2016 Crispy Mountain GmbH. All rights reserved.
//

import Foundation
import UIKit

private let numberFormatter: NSNumberFormatter = {
    let f = NSNumberFormatter()
    f.minimumFractionDigits = 0
    f.maximumFractionDigits = 3
    return f
}()

public class DecimalInputTextField: UITextField {
    private var didSetup = false
    private var _decimalInputView: UIView!
    
    @IBInspectable public var showsQuickBar = true {
        didSet { setupInputView() }
    }
    
    private func setupInputView() {
        guard !didSetup else { return }
        
        let inputView = CustomKeyboardView(frame: CGRectMake(0, 0, 183, 333))
        inputView.autoresizingMask = [.None]
        let decimalButtonCaptions = "123456789 0⌫".characters.map { String($0) }.chunk(3)
        
        let decimalPad = CustomKeyboardKeyGroup(keyboard: inputView, captions:
            decimalButtonCaptions, applicator: {[weak self] (button) in
                guard let weakSelf = self else { return }
                
                if button.isDeleteButton {
                    weakSelf.deleteBackward()
                } else {
                    weakSelf.insertText(button.caption)
                }
            })
        
        inputView.addKeyGroup(decimalPad)

        if(showsQuickBar) {
            let quickAddButtonCaptions = [["+1", "+5", "+10"], ["+50", "+100", "+500"]]
            let quickAddPad = CustomKeyboardKeyGroup(keyboard: inputView, captions:
                quickAddButtonCaptions, applicator: { [weak self] (button) in
                    guard let weakSelf = self else { return }
                    
                    let number = numberFormatter.numberFromString(weakSelf.text ?? "")?.doubleValue ?? 0
                    let buttonValue = Double(button.caption)!
                    let newNumber = NSNumber(double:number + buttonValue)
                    let newString = numberFormatter.stringFromNumber(newNumber)
                    
                    weakSelf.text = newString
                })
        
            inputView.addKeyGroup(quickAddPad)
        }
        _decimalInputView = inputView
        
        didSetup = true
    }
    
    override public var inputView: UIView? {
        get { setupInputView(); return _decimalInputView }
        set { }
    }
}

private extension Array {
    func chunk(size: Int = 1) -> [[Element]] {
        var result = [[Element]]()
        var chunk = -1
        for (index, element) in enumerate() {
            if index % size == 0 {
                result.append([Element]())
                chunk += 1
            }
            result[chunk].append(element)
        }
        return result
    }
}