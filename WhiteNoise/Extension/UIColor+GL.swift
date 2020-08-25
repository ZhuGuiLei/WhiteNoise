//
//  UIColor+GL.swift
//  RealTimeBid
//
//  Created by apple on 2020/6/1.
//  Copyright © 2020 apple. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    
    static func color(l lightColor: UIColor, d darkColor: UIColor) -> UIColor {
        if #available(iOS 13.0, *) {
            let color = UIColor.init { (traitCollection) -> UIColor in
                if traitCollection.userInterfaceStyle == .light {
                    return lightColor
                } else {
                    return darkColor
                }
            }
            return color
            
        } else {
            return lightColor
        }
    }
}

extension UIColor {
    
    static var main = rgb(48, 110, 229)
    
    static var bgc_table = color(l: .white(245), d: .w17)
    static var bgc_cell = color(l: .white, d: .rgb(30, 30, 39))
    
    static var w51 = white(51)
    static var w102 = white(102)
    static var w153 = white(153)
    
    static var w248 = white(248)
    
    static var w88 = rgb(87, 86, 94)
    static var w17 = rgb(17, 17, 24)
    
    static var w51_248 = color(l: .white(51), d: .white(248))
    static var w102_153 = color(l: .white(102), d: .white(153))
    static var w102_98 = color(l: .w102, d: .w88)
    static var w153_98 = color(l: .w153, d: .w88)
    
    
    static var line = color(l: .white(230), d: .rgb(57, 57, 75))
    
    
    /// 颜色黑-白
    ///
    /// - Parameter white: 0:黑, 255:白
    /// - Returns: color
    static func white(_ white: UInt8) -> UIColor {
        return rgb(white, white, white)
        
        
    }
    /// 颜色黑-白
    ///
    /// - Parameter white: 0:黑, 255:白
    /// ///   - alpha: 0.0-1.0
    /// - Returns: color
    static func whiteAlpha(_ alpha: CGFloat) -> UIColor {
        return rgba(255, 255, 255, alpha)
        
    }
    
    /// 快捷颜色
    ///
    /// - Parameters:
    ///   - hex: 0x000000-0xffffff
    ///   - alpha: 0.0-1.0
    static func hex(_ hex: UInt32, _ alpha: CGFloat = 1) -> UIColor {
        return rgba(UInt8((hex & 0xff0000) >> 16), UInt8((hex & 0xff00) >> 8), UInt8((hex & 0xff)), alpha)
    }
    
    /// 快捷颜色
    ///
    /// - Parameters:
    ///   - red: 0-255
    ///   - green: 0-255
    ///   - blue: 0-255
    /// - Returns: color
    static func rgb(_ red: UInt8, _ green: UInt8, _ blue: UInt8) -> UIColor {
        return rgba(red, green, blue, 1)
    }
    
    /// 快捷颜色
    ///
    /// - Parameters:
    ///   - red: 0-255
    ///   - green: 0-255
    ///   - blue: 0-255
    ///   - alpha: 0.0-1.0
    /// - Returns: color
    static func rgba(_ red: UInt8, _ green: UInt8, _ blue: UInt8, _ alpha: CGFloat) -> UIColor {
        return UIColor.init(red: CGFloat(red)/255.0, green: CGFloat(green)/255.0, blue: CGFloat(blue)/255.0, alpha: alpha)
    }
    

    /// 随即色
    ///
    /// - Returns: color
    static func random() -> UIColor {
//        let arr = [UIColor.rgb(0xd1, 0xae, 0x9d),
//                   UIColor.rgb(0x8c, 0xa3, 0xcd),
//                   UIColor.rgb(0x7d, 0xb3, 0xd9),
//                   UIColor.rgb(0xbc, 0x9e, 0xdd),
//                   UIColor.rgb(0x84, 0xca, 0xb0)]
//        return arr[Int(arc4random_uniform(4))]
        return UIColor.rgb(UInt8(Rand(255)), UInt8(Rand(255)), UInt8(Rand(255)))
    }
    
    private static func Rand(_ x: UInt32) -> UInt32 {
        return arc4random_uniform(x)
    }
    
}


/// 梯度
///
/// - level: 水平
/// - vertical: 竖直
enum GradientChangeDirection {
    /// 水平
    case level
    /// 竖直
    case vertical
    case downDiagonalLine
    case upwardDiagonalLine
}

extension UIColor
{
    
    /// 梯度色
    ///
    /// - Parameters:
    ///   - size: 尺寸，不可为zero
    ///   - direction: 渐变方向，level，vertical，downDiagonalLine，upwardDiagonalLine
    ///   - startColor: 开始颜色
    ///   - endColor: 结束颜色
    /// - Returns: 指定尺寸的渐变色
    static func gradientColor(size: CGSize, direction: GradientChangeDirection, startColor: UIColor, endColor: UIColor) -> UIColor
    {
        if size.width == 0 || size.height == 0 {
            return startColor
        }
        let gradientColors = [startColor.cgColor, endColor.cgColor]
        
        //创建CAGradientLayer对象并设置参数
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = CGRect.init(x: 0, y: 0, width: size.width, height: size.height)
        gradientLayer.colors = gradientColors
        
        var startPoint = CGPoint.zero
        if direction == .upwardDiagonalLine {
            startPoint = CGPoint.init(x: 0.0, y: 1.0)
        }
        gradientLayer.startPoint = startPoint
        
        var endPoint = CGPoint.zero
        switch direction {
        case .level:
            endPoint = CGPoint.init(x: 1.0, y: 0.0)
        case .vertical:
            endPoint = CGPoint.init(x: 0.0, y: 1.0)
        case .downDiagonalLine:
            endPoint = CGPoint.init(x: 1.0, y: 1.0)
        case .upwardDiagonalLine:
            endPoint = CGPoint.init(x: 1.0, y: 0.0)
        }
        gradientLayer.endPoint = endPoint
        
        
        UIGraphicsBeginImageContext(gradientLayer.frame.size);
        gradientLayer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext() ?? UIImage()
        UIGraphicsEndImageContext();
        return UIColor.init(patternImage: image)
    }
}



