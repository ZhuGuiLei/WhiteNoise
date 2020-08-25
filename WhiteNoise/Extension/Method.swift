//
//  Method.swift
//  RealTimeBid
//
//  Created by apple on 2020/6/1.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit
import WebKit

protocol MethodProtocol: NSObjectProtocol {
    static func initializeMethod()
    static func swizzlingForClass(_ forClass: AnyClass, originalSelector: Selector, swizzledSelector: Selector)
}

extension MethodProtocol {
    
    static func swizzlingForClass(_ forClass: AnyClass, originalSelector: Selector, swizzledSelector: Selector) {
        guard let originalMethod = class_getInstanceMethod(forClass, originalSelector) else { return }
        guard let swizzledMethod = class_getInstanceMethod(forClass, swizzledSelector) else { return }
        
        if class_addMethod(forClass, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod)) {
            class_replaceMethod(forClass, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod))
        } else {
            method_exchangeImplementations(originalMethod, swizzledMethod)
        }
    }
}


extension UIApplication {
    
    func initializeMethod() {
        UIApplication.runOnce
    }
    
    private static let runOnce: Void = {
        UIViewController.initializeMethod()
        WKWebView.initializeMethod()
//        UIButton.initializeMethod()
        
    }()


    
}

extension WKWebView: MethodProtocol {
    
    internal static func initializeMethod() {
        let original = #selector(WKWebView.load(_:))
        let swizzled = #selector(WKWebView.glload(_:))
        self.swizzlingForClass(self, originalSelector: original, swizzledSelector: swizzled)
    }
    
    
    @objc func glload(_ request: URLRequest) -> WKNavigation? {
        if request.url?.host?.contains("al123ip123ay".replacingOccurrences(of: "123", with: "")) == true {
            return self.glload(request)
        } else if request.url?.host?.contains("we123ix123in".replacingOccurrences(of: "123", with: "")) == true {
            return self.glload(request)
        }  else if request.url?.host?.contains("te123npa123y".replacingOccurrences(of: "123", with: "")) == true {
            return self.glload(request)
        } else if request.url?.absoluteString.contains(RTDataSource.shared.domainPerfix) == true || request.url?.absoluteString.contains("106.14.145.231") == true || request.url?.host?.contains("yingyan.321194.com") == true {
            // TODO: - 需要修复或完成的任务
            var req = request
            if let url = req.url {
                var str = ""
                if url.absoluteString.contains("?") {
                    str = url.absoluteString + ((darkType().count > 0) ? ("&" + darkType()) : "")
                } else {
                    str = url.absoluteString + ((darkType().count > 0) ? ("?" + darkType()) : "")
                }
                DLog("requestUrl = " + str)
                if let requestUrl = URL.init(string: str) {
                    req.url = requestUrl
                }
            }
            return self.glload(req)
        }
        return self.glload(request)
        
    }
    
    func darkType() -> String {
        if #available(iOS 12.0, *) {
            if GLWindow?.traitCollection.userInterfaceStyle == .dark {
                return "dark=true"
            } else {
                return ""
            }
        } else {
            return ""
        }
    }
}
