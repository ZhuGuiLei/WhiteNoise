//
//  UIImage+MDExtension.swift
//  MDCredit
//
//  Created by Alan on 2017/11/10.
//  Copyright © 2017年 MD. All rights reserved.
//

import Foundation
import UIKit

extension UIImage{
    
    /// 颜色创建Image
    static func image(color: UIColor) -> UIImage
    {
        return UIImage.image(color: color, size: CGSize.init(width: 1, height: 1))
    }
    
    /// 颜色创建Image
    /// - Parameter size: 尺寸
    static func image(color: UIColor, size: CGSize) -> UIImage
    {
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context!.setFillColor(color.cgColor)
        context!.fill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
    
    

    
}
