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
    
    required init(caption: String, isDeleteButton: Bool, applicator: @escaping Applicator) {
        self.caption = caption
        self.isDeleteButton = isDeleteButton
        self.applicator = applicator
        super.init(frame: CGRect.zero)
        setupDefaults()
    }
    
    override init(frame: CGRect) {
        fatalError("initWithFrame not implemented")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("initWithCoder not implemented")
    }
    
    fileprivate let shadowLayer = CAShapeLayer()
    fileprivate let cornerRadius: CGFloat = 8.0
    
    fileprivate var normalBackgroundColor: CGColor!
    fileprivate var highlightedBackgroundColor: CGColor!
    
    override var isHighlighted: Bool {
        didSet {
            if isHighlighted {
                layer.backgroundColor = highlightedBackgroundColor
            } else {
                layer.backgroundColor = normalBackgroundColor
            }
        }
    }
    
    @objc func touchUpInside(_ sender: CustomKeyboardKey?) {
        applicator(self)
    }
    
    fileprivate func setupDefaults() {
        addTarget(self, action: #selector(CustomKeyboardKey.touchUpInside(_:)), for: .touchUpInside)
        
        let grayColor = UIColor(red: 0.68, green: 0.70, blue: 0.75, alpha: 1.00).cgColor
        let whiteColor = UIColor(white: 1.00, alpha: 1.0).cgColor
        let isBlankKey = caption.trimmedString.isEmpty
        let shouldBeInverted = isDeleteButton || isBlankKey
        
        normalBackgroundColor = shouldBeInverted ? grayColor : whiteColor
        highlightedBackgroundColor = shouldBeInverted ? whiteColor : grayColor
        
        isEnabled = !isBlankKey
        
        layer.backgroundColor = normalBackgroundColor
        
        if isDeleteButton {
            titleLabel?.font = UIFont.systemFont(ofSize: 24.0, weight: UIFont.Weight.thin)
        } else {
            titleLabel?.font = UIFont.systemFont(ofSize: 30.0, weight: UIFont.Weight.light)
        }
        
        setTitleColor(UIColor.black, for: UIControlState())
        setTitle(caption, for: UIControlState())
        
        layer.shadowColor = UIColor(white: 0.55, alpha: 1.0).cgColor
        layer.shadowOffset = CGSize(width: 0, height: 1)
        layer.shadowRadius = 0.0
        layer.shadowOpacity = 1.0
        layer.masksToBounds = false
        layer.cornerRadius = cornerRadius
        clipsToBounds = false
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius).cgPath
    }
    
    override var intrinsicContentSize : CGSize {
        return CGSize(width: 80, height: 74)
    }
}

private extension String {
    var trimmedString: String {
        return self.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    }
}
