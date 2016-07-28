//
//  SoftKeyboardView.swift
//  Test
//
//  Created by Joachim Garth on 23/04/16.
//  Copyright © 2016 Crispy Mountain GmbH. All rights reserved.
//

import Foundation
import UIKit

@objc protocol CustomKeyboardDelegate: class {
    optional func softKeyPressed(key: CustomKeyboardKey)
}

class CustomKeyboardView: UIView {
    weak var delegate: CustomKeyboardDelegate?
    private var keyboardGroupViewsXConstraints: [NSLayoutConstraint] = []
    private var keyboardGroupViews: [CustomKeyboardKeyGroup] = []
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    override func prepareForInterfaceBuilder() {
        setup()
    }
    
    @IBAction
    func softKeyPressed(sender: AnyObject?) {
        guard let key = sender as? CustomKeyboardKey,
            let delegate = delegate else { return }
        
        delegate.softKeyPressed?(key)
    }
    
    // MARK: - Private
    
    private var didSetup = false
    private let innerView = UIStackView(frame: CGRectZero)
    
    private func setup() {
        guard !didSetup else { return }
        
        backgroundColor = UIColor(hue: 0.61, saturation: 0.04, brightness: 0.86, alpha: 1.00)
        innerView.backgroundColor = UIColor.clearColor()
        innerView.alignment = .Leading
        innerView.distribution = .EqualCentering
        innerView.spacing = 24.0
        innerView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(innerView)

        let outerMargin: CGFloat = 6.0
        
        // Setup inner view centering
        addConstraint(NSLayoutConstraint(item: innerView, attribute: .CenterX, relatedBy: .Equal, toItem: self, attribute: .CenterX, multiplier: 1.0, constant: 0))
        addConstraint(NSLayoutConstraint(item: innerView, attribute: .CenterY, relatedBy: .Equal, toItem: self, attribute: .CenterY, multiplier: 1.0, constant: -outerMargin))
        
        // Setup inner view minimum spacing
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(
            "H:|-(>=outerMargin)-[innerView]-(>=outerMargin)-|", options: [], metrics: ["outerMargin": outerMargin],
            views: ["innerView": innerView]))
        
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(
            "V:|[innerView]-(>=outerMargin)-|", options: [], metrics: ["outerMargin": outerMargin],
            views: ["innerView": innerView]))
        
        didSetup = true
    }
    
    func addKeyGroup(group: CustomKeyboardKeyGroup) {
        keyboardGroupViews.append(group)
        innerView.addArrangedSubview(group)
    }
}