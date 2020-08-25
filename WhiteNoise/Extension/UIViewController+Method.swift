//
//  UIViewController+RT.swift
//  RealTimeBid
//
//  Created by apple on 2020/6/1.
//  Copyright © 2020 apple. All rights reserved.
//

import Foundation
import UIKit

/// 方法替换
extension UIViewController: MethodProtocol {
      
    private static var once = true
    internal static func initializeMethod() {
        if once == false {
            return
        }
        once = false
        var original = #selector(UIViewController.present(_:animated:completion:))
        var swizzled = #selector(UIViewController.glpresent(_:animated:completion:))
        self.swizzlingForClass(self, originalSelector: original, swizzledSelector: swizzled)
        
        original = #selector(UIViewController.dismiss(animated:completion:))
        swizzled = #selector(UIViewController.gldismiss(animated:completion:))
        self.swizzlingForClass(self, originalSelector: original, swizzledSelector: swizzled)
        
        original = #selector(UIViewController.viewDidAppear(_:))
        swizzled = #selector(UIViewController.glviewDidAppear(_:))
        self.swizzlingForClass(self, originalSelector: original, swizzledSelector: swizzled)
        
        original = #selector(UIViewController.viewWillDisappear(_:))
        swizzled = #selector(UIViewController.glviewWillDisappear(_:))
        self.swizzlingForClass(self, originalSelector: original, swizzledSelector: swizzled)
        
        original = #selector(UIViewController.viewDidDisappear(_:))
        swizzled = #selector(UIViewController.glviewDidDisappear(_:))
        self.swizzlingForClass(self, originalSelector: original, swizzledSelector: swizzled)
        
    }

    
    @objc private func glpresent(_ viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)? = nil) {
        DLog("glpresent")
        if viewControllerToPresent.modalPresentationStyle == .overFullScreen || viewControllerToPresent.modalPresentationStyle == .overCurrentContext {
            self.definesPresentationContext = true
        } else {
            if #available(iOS 13.0, *) {
                if viewControllerToPresent.modalPresentationStyle != .overFullScreen && viewControllerToPresent.modalPresentationStyle != .overCurrentContext {
                    viewControllerToPresent.modalPresentationStyle = .fullScreen
                }
            }
        }
        self.glpresent(viewControllerToPresent, animated: flag, completion: completion)
    }
    
    
    @objc func gldismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
        self.gldismiss(animated: flag) {
            completion?()
            UIViewController.topVC().setNeedsStatusBarAppearanceUpdate()
        }
    }
    
    @objc func glviewDidAppear(_ animated: Bool) {
        self.glviewDidAppear(animated)
    }
    
    @objc func glviewWillDisappear(_ animated: Bool) {
        self.glviewWillDisappear(animated)
        self.view.endEditing(true)
    }
    
    @objc func glviewDidDisappear(_ animated: Bool) {
        self.glviewDidDisappear(animated)
    }
}

