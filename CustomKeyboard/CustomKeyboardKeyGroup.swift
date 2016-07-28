//
//  SoftKeyboardButtonGroup.swift
//  Test
//
//  Created by Joachim Garth on 08/05/16.
//  Copyright © 2016 Crispy Mountain GmbH. All rights reserved.
//

import Foundation
import UIKit

class CustomKeyboardKeyGroup: UIView {
    private weak var keyboardView: CustomKeyboardView?
    private let buttonCaptions: [[String]]
    private var buttons: [CustomKeyboardKey] = []
    private var applicator: CustomKeyboardKey.Applicator
    private var didSetup: Bool = false
    
    required init(keyboard: CustomKeyboardView, captions: [[String]], applicator: CustomKeyboardKey.Applicator) {
        self.keyboardView = keyboard
        self.buttonCaptions = captions
        self.applicator = applicator
        super.init(frame: CGRectZero)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    override init(frame: CGRect) {
        fatalError()
    }
    
    override func prepareForInterfaceBuilder() {
        setup()
    }
    
    private func setup() {
        guard !didSetup else { return }
        
        var previousStackView: UIStackView?
        var stackViews: [UIStackView] = []
        
        let innerMargin: CGFloat = 12.0
        
        for buttonRow in buttonCaptions {
            
            let buttonsForRow: [CustomKeyboardKey] = buttonRow.map { (character) in
                let isDeleteButton = (character == "⌫")
                let button = CustomKeyboardKey(caption: character, isDeleteButton: isDeleteButton, applicator: self.applicator)
                button.translatesAutoresizingMaskIntoConstraints = false
                button.addTarget(keyboardView, action: #selector(CustomKeyboardView.softKeyPressed(_:)), forControlEvents: .TouchUpInside)
                button.heightAnchor.constraintEqualToAnchor(button.widthAnchor, multiplier: (80.0/74.0)).active = true
                buttons.append(button)
                return button
            }
            
            let stackViewForRow = UIStackView(arrangedSubviews: buttonsForRow)
            stackViewForRow.translatesAutoresizingMaskIntoConstraints = false
            stackViewForRow.alignment = .Fill
            stackViewForRow.spacing = innerMargin
            stackViewForRow.distribution = .FillEqually
            stackViews.append(stackViewForRow)
            addSubview(stackViewForRow)
            
            if let topStackView = previousStackView {
                // Add top spacing to previous stack view
                addConstraint(NSLayoutConstraint(item: stackViewForRow,
                    attribute: .Top, relatedBy: .Equal, toItem: topStackView,
                    attribute: .Bottom, multiplier: 1.0, constant: innerMargin))
                
                // Add equal height constraint to previous stack view
                addConstraint(NSLayoutConstraint(item: stackViewForRow,
                    attribute: .Height, relatedBy: .Equal, toItem: topStackView,
                    attribute: .Height, multiplier: 1.0, constant: 0))
            }
            
            // Add left-right spacing to inner view
            addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-(0)-[stackView]-(0)-|",
                options: [], metrics: nil, views: ["stackView": stackViewForRow]))
            
            previousStackView = stackViewForRow
        }
        
        // Add top and bottom stack view constraints to inner view
        addConstraint(NSLayoutConstraint(item: stackViews.first!, attribute: .Top,
            relatedBy: .Equal, toItem: self, attribute: .Top, multiplier: 1.0, constant: 0))
        addConstraint(NSLayoutConstraint(item: stackViews.last!, attribute: .Bottom,
            relatedBy: .Equal, toItem: self, attribute: .Bottom, multiplier: 1.0, constant: 0))
        
        didSetup = true
    }


}
