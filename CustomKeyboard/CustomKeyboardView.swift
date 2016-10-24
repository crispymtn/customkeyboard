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
    @objc optional func softKeyPressed(_ key: CustomKeyboardKey)
}

class CustomKeyboardView: UIView {
    weak var delegate: CustomKeyboardDelegate?
    fileprivate var keyboardGroupViewsXConstraints: [NSLayoutConstraint] = []
    fileprivate var keyboardGroupViews: [CustomKeyboardKeyGroup] = []
    
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
    func softKeyPressed(_ sender: AnyObject?) {
        guard let key = sender as? CustomKeyboardKey,
            let delegate = delegate else { return }
        
        delegate.softKeyPressed?(key)
    }
    
    // MARK: - Private
    
    fileprivate var didSetup = false
    fileprivate let innerView = UIStackView(frame: CGRect.zero)
    
    fileprivate func setup() {
        guard !didSetup else { return }
        
        backgroundColor = UIColor(hue: 0.61, saturation: 0.04, brightness: 0.86, alpha: 1.00)
        innerView.backgroundColor = UIColor.clear
        innerView.alignment = .leading
        innerView.distribution = .equalCentering
        innerView.spacing = 24.0
        innerView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(innerView)

        let outerMargin: CGFloat = 6.0
        
        // Setup inner view centering
        addConstraint(NSLayoutConstraint(item: innerView, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1.0, constant: 0))
        addConstraint(NSLayoutConstraint(item: innerView, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1.0, constant: -outerMargin))
        
        // Setup inner view minimum spacing
        addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-(>=outerMargin)-[innerView]-(>=outerMargin)-|", options: [], metrics: ["outerMargin": outerMargin],
            views: ["innerView": innerView]))
        
        addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "V:|[innerView]-(>=outerMargin)-|", options: [], metrics: ["outerMargin": outerMargin],
            views: ["innerView": innerView]))
        
        didSetup = true
    }
    
    func addKeyGroup(_ group: CustomKeyboardKeyGroup) {
        keyboardGroupViews.append(group)
        innerView.addArrangedSubview(group)
    }
}
