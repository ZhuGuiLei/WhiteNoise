//
//  UIButton+Extension.swift
//  RealTimeBid
//
//  Created by apple on 2019/9/11.
//  Copyright © 2019 JAVIS. All rights reserved.
//

import UIKit

/**
 UIButton图像文字同时存在时---图像相对于文字的位置
 
 - top:    图像在上
 - left:   图像在左
 - right:  图像在右
 - bottom: 图像在下
 */
enum ButtonImageEdgeInsetsStyle {
    case top, left, right, bottom
}

extension UIButton {
    
    func imagePosition(at style: ButtonImageEdgeInsetsStyle, space: CGFloat) {
        //得到imageView和titleLabel的宽高
        let imageWidth = self.imageView?.frame.size.width
        let imageHeight = self.imageView?.frame.size.height
        
        var labelWidth: CGFloat! = 0.0
        var labelHeight: CGFloat! = 0.0
        
        labelWidth = self.titleLabel?.intrinsicContentSize.width
        labelHeight = self.titleLabel?.intrinsicContentSize.height
        
        //初始化imageEdgeInsets和labelEdgeInsets
        var imageEdgeInsets = UIEdgeInsets.zero
        var labelEdgeInsets = UIEdgeInsets.zero
        
        //根据style和space得到imageEdgeInsets和labelEdgeInsets的值
        switch style {
        case .top:
            //上 左 下 右
            imageEdgeInsets = UIEdgeInsets(top: -labelHeight-space/2, left: 0, bottom: 0, right: -labelWidth)
            labelEdgeInsets = UIEdgeInsets(top: 0, left: -imageWidth!, bottom: -imageHeight!-space/2, right: 0)
            break;
            
        case .left:
            imageEdgeInsets = UIEdgeInsets(top: 0, left: -space/2, bottom: 0, right: space)
            labelEdgeInsets = UIEdgeInsets(top: 0, left: space/2, bottom: 0, right: -space/2)
            break;
            
        case .bottom:
            imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: -labelHeight!-space/2, right: -labelWidth)
            labelEdgeInsets = UIEdgeInsets(top: -imageHeight!-space/2, left: -imageWidth!, bottom: 0, right: 0)
            break;
            
        case .right:
            imageEdgeInsets = UIEdgeInsets(top: 0, left: labelWidth+space/2, bottom: 0, right: -labelWidth-space/2)
            labelEdgeInsets = UIEdgeInsets(top: 0, left: -imageWidth!-space/2, bottom: 0, right: imageWidth!+space/2)
            break;
            
        }
        
        self.titleEdgeInsets = labelEdgeInsets
        self.imageEdgeInsets = imageEdgeInsets
    }
}
