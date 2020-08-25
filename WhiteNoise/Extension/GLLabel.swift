//
//  GLLabel.swift
//  RealTimeBid
//
//  Created by JAVIS on 2019/9/5.
//  Copyright © 2019 JAVIS. All rights reserved.
//

import Foundation

class GLLabel : UILabel {
    
    var tapBlock: BaseTypeBlock<GLLabel>?
    
    var padding = UIEdgeInsets.zero
    
    @IBInspectable
    var paddingLeft: CGFloat {
        get { return padding.left }
        set { padding.left = newValue }
    }
    
    @IBInspectable
    var paddingRight: CGFloat {
        get { return padding.right }
        set { padding.right = newValue }
    }
    
    @IBInspectable
    var paddingTop: CGFloat {
        get { return padding.top }
        set { padding.top = newValue }
    }
    
    @IBInspectable
    var paddingBottom: CGFloat {
        get { return padding.bottom }
        set { padding.bottom = newValue }
    }
    
    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: padding))
    }
    
    override func textRect(forBounds bounds: CGRect, limitedToNumberOfLines numberOfLines: Int) -> CGRect {
        let insets = self.padding
        var rect = super.textRect(forBounds: bounds.inset(by: insets), limitedToNumberOfLines: numberOfLines)
        rect.origin.x    -= insets.left
        rect.origin.y    -= insets.top
        rect.size.width  += (insets.left + insets.right)
        rect.size.height += (insets.top + insets.bottom)
        return rect
    }
    
}

extension GLLabel
{
    
    @IBInspectable var canTap: Bool {
        get {
            return self.isUserInteractionEnabled
        }
        set {
            self.isUserInteractionEnabled = newValue
            if newValue {
                self.removeAllGestureRecognizer()
                let tap = UITapGestureRecognizer.init(target: self, action: #selector(labelTapAction))
                self.addGestureRecognizer(tap)
            } else {
                self.removeAllGestureRecognizer()
            }
        }
    }
    
    @objc func labelTapAction() {
        self.tapBlock?(self)
    }
}
