//
//  PinButton.swift
//  Test
//
//  Created by Joachim Garth on 19/04/16.
//  Copyright © 2016 Crispy Mountain GmbH. All rights reserved.
//

import UIKit

class CustomKeyboardKey: UIButton {
    let isDeleteButton: Bool
    let caption: String
    let applicator: Applicator // This gets executed on touchUpInside before the delegate is notified

    typealias Applicator = ((CustomKeyboardKey) -> (Void))
    
    required init(caption: String, isDeleteButton: Bool, applicator: Applicator) {
        self.caption = caption
        self.isDeleteButton = isDeleteButton
        self.applicator = applicator
        super.init(frame: CGRectZero)
        setupDefaults()
    }
    
    override init(frame: CGRect) {
        fatalError("initWithFrame not implemented")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("initWithCoder not implemented")
    }
    
    private let shadowLayer = CAShapeLayer()
    private let cornerRadius: CGFloat = 8.0
    
    private var normalBackgroundColor: CGColor!
    private var highlightedBackgroundColor: CGColor!
    
    override var highlighted: Bool {
        didSet {
            if highlighted {
                layer.backgroundColor = highlightedBackgroundColor
            } else {
                layer.backgroundColor = normalBackgroundColor
            }
        }
    }
    
    func touchUpInside(sender: CustomKeyboardKey?) {
        applicator(self)
    }
    
    private func setupDefaults() {
        addTarget(self, action: #selector(CustomKeyboardKey.touchUpInside(_:)), forControlEvents: .TouchUpInside)
        
        let grayColor = UIColor(red: 0.68, green: 0.70, blue: 0.75, alpha: 1.00).CGColor
        let whiteColor = UIColor(white: 1.00, alpha: 1.0).CGColor
        let isBlankKey = caption.trimmedString.isEmpty
        let shouldBeInverted = isDeleteButton || isBlankKey
        
        normalBackgroundColor = shouldBeInverted ? grayColor : whiteColor
        highlightedBackgroundColor = shouldBeInverted ? whiteColor : grayColor
        
        enabled = !isBlankKey
        
        layer.backgroundColor = normalBackgroundColor
        
        if isDeleteButton {
            titleLabel?.font = UIFont.systemFontOfSize(24.0, weight: UIFontWeightThin)
        } else {
            titleLabel?.font = UIFont.systemFontOfSize(30.0, weight: UIFontWeightLight)
        }
        
        setTitleColor(UIColor.blackColor(), forState: .Normal)
        setTitle(caption, forState: .Normal)
        
        layer.shadowColor = UIColor(white: 0.55, alpha: 1.0).CGColor
        layer.shadowOffset = CGSizeMake(0, 1)
        layer.shadowRadius = 0.0
        layer.shadowOpacity = 1.0
        layer.masksToBounds = false
        layer.cornerRadius = cornerRadius
        clipsToBounds = false
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius).CGPath
    }
    
    override func intrinsicContentSize() -> CGSize {
        return CGSizeMake(80, 74)
    }
}

private extension String {
    var trimmedString: String {
        return self.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
    }
}