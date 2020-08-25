//
//  UIView-Extension.swift
//  Test
//
//  Created by Stev Stark on 2019/7/7.
//  Copyright © 2019 Stev Stark. All rights reserved.
//

import UIKit

extension UIView {
    
    var x : CGFloat {
        set {
            var frame = self.frame
            frame.origin.x = newValue
            self.frame = frame
        }
        get {
            return self.frame.origin.x
        }
    }
    
    var y : CGFloat {
        set {
            var frame = self.frame
            frame.origin.y = newValue
            self.frame = frame
        }
        get {
            return self.frame.origin.y
        }
    }
    
    var right : CGFloat {
        set {
            var frame = self.frame
            frame.origin.x = newValue - self.width
            self.frame = frame
        }
        get {
            return self.frame.maxX
        }
    }
    
    var bottom : CGFloat {
        set {
            var frame = self.frame
            frame.origin.y = newValue - self.height
            self.frame = frame
        }
        get {
            return self.frame.maxY
        }
    }
    
    var width : CGFloat {
        set {
            var frame = self.frame
            frame.size.width = newValue
            self.frame = frame
        }
        get {
            return self.frame.size.width
        }
    }
    
    var height : CGFloat {
        set {
            var frame = self.frame
            frame.size.height = newValue
            self.frame = frame
        }
        get {
            return self.frame.size.height
        }
    }
    
    var size : CGSize {
        set {
            var frame = self.frame
            frame.size = newValue
            self.frame = frame
        }
        get {
            return self.frame.size
        }
    }
    
    var centerX : CGFloat {
        set {
            var center = self.center
            center.x = newValue
            self.center = center
        }
        get {
            return self.center.x
        }
    }
    
    var centerY : CGFloat {
        set {
            var center = self.center
            center.y = newValue
            self.center = center
        }
        get {
            return self.center.y
        }
    }
    
    //  圆角
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        } set {
            layer.masksToBounds = (newValue > 0)
            layer.cornerRadius = newValue
        }
    }
    //  边线宽度
    @IBInspectable var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        } set {
            layer.borderWidth = newValue
        }
    }
    //  边线颜色
    @IBInspectable var borderColor: UIColor {
        get {
            return layer.borderUIColor
        } set {
            layer.borderColor = newValue.cgColor
        }
    }
}


//  设置边线颜色
extension CALayer {
    var borderUIColor: UIColor {
        get {
            return UIColor(cgColor: self.borderColor!)
        } set {
            self.borderColor = newValue.cgColor
        }
    }
}


class GLLineView: UIView {
    @IBInspectable
    
    var lcolor: UIColor? {
        get { return backgroundColor }
        set { backgroundColor = newValue }
    }
    
    var dcolor: UIColor? {
        get { return backgroundColor }
        set { backgroundColor = newValue }
    }
    
}
