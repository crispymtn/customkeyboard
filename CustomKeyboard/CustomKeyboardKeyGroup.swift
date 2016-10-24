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
    fileprivate weak var keyboardView: CustomKeyboardView?
    fileprivate let buttonCaptions: [[String]]
    fileprivate var buttons: [CustomKeyboardKey] = []
    fileprivate var applicator: CustomKeyboardKey.Applicator
    fileprivate var didSetup: Bool = false
    
    required init(keyboard: CustomKeyboardView, captions: [[String]], applicator: @escaping CustomKeyboardKey.Applicator) {
        self.keyboardView = keyboard
        self.buttonCaptions = captions
        self.applicator = applicator
        super.init(frame: CGRect.zero)
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
    
    fileprivate func setup() {
        guard !didSetup else { return }
        
        var previousStackView: UIStackView?
        var stackViews: [UIStackView] = []
        
        let innerMargin: CGFloat = 12.0
        
        for buttonRow in buttonCaptions {
            
            let buttonsForRow: [CustomKeyboardKey] = buttonRow.map { (character) in
                let isDeleteButton = (character == "⌫")
                let button = CustomKeyboardKey(caption: character, isDeleteButton: isDeleteButton, applicator: self.applicator)
                button.translatesAutoresizingMaskIntoConstraints = false
                button.addTarget(keyboardView, action: #selector(CustomKeyboardView.softKeyPressed(_:)), for: .touchUpInside)
                button.heightAnchor.constraint(equalTo: button.widthAnchor, multiplier: (80.0/74.0)).isActive = true
                buttons.append(button)
                return button
            }
            
            let stackViewForRow = UIStackView(arrangedSubviews: buttonsForRow)
            stackViewForRow.translatesAutoresizingMaskIntoConstraints = false
            stackViewForRow.alignment = .fill
            stackViewForRow.spacing = innerMargin
            stackViewForRow.distribution = .fillEqually
            stackViews.append(stackViewForRow)
            addSubview(stackViewForRow)
            
            if let topStackView = previousStackView {
                // Add top spacing to previous stack view
                addConstraint(NSLayoutConstraint(item: stackViewForRow,
                    attribute: .top, relatedBy: .equal, toItem: topStackView,
                    attribute: .bottom, multiplier: 1.0, constant: innerMargin))
                
                // Add equal height constraint to previous stack view
                addConstraint(NSLayoutConstraint(item: stackViewForRow,
                    attribute: .height, relatedBy: .equal, toItem: topStackView,
                    attribute: .height, multiplier: 1.0, constant: 0))
            }
            
            // Add left-right spacing to inner view
            addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(0)-[stackView]-(0)-|",
                options: [], metrics: nil, views: ["stackView": stackViewForRow]))
            
            previousStackView = stackViewForRow
        }
        
        // Add top and bottom stack view constraints to inner view
        addConstraint(NSLayoutConstraint(item: stackViews.first!, attribute: .top,
            relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1.0, constant: 0))
        addConstraint(NSLayoutConstraint(item: stackViews.last!, attribute: .bottom,
            relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1.0, constant: 0))
        
        didSetup = true
    }


}
