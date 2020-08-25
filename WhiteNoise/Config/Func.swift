//
//  RTFunc.swift
//  RealTimeBid
//
//  Created by apple on 2020/6/3.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit

/// 是否登录
var IsLogin: Bool {
    get {
        return !(RTDataSource.shared.token ?? "").isEmpty
    }
    set {
        if newValue {
            
        } else {
            
            RTDataSource.shared.token = nil
//            RTUserInfoModel.shared.clear()
        }
    }
}

var AppShenHe: Bool {
    get {
        return UserDefaults.standard.bool(forKey: "AppShe123nHe")
    }
    set {
        UserDefaults.standard.set(newValue, forKey: "AppShe123nHe")
    }
}


//var IsVip: Bool {
//    get {
//        return RTUserInfoModel.shared.vip ?? false
//    }
//    set {
//        RTUserInfoModel.shared.vip = newValue
//    }
//}


//let AgreementUrl =  RTDataSource.shared.initModel?.appAgreementUrl ?? "http://h5.yingyan.321194.com/view/RealTimeBid/shishiZb_agreement.html"
//let PrivacyUrl =    RTDataSource.shared.initModel?.appPrivacyUrl ?? "http://h5.yingyan.321194.com/view/RealTimeBid/shishiZb_privacy.html"
//
///// 用户注册协议
//func ToAgreement(_ nav: UINavigationController?) {
//    let vc = GLWebVC.init()
//    vc.url = AgreementUrl
//    nav?.pushViewController(vc, animated: true)
//}
//
///// 用户隐私协议
//func ToPrivacy(_ nav: UINavigationController?) {
//    let vc = GLWebVC.init()
//    vc.url = PrivacyUrl
//    nav?.pushViewController(vc, animated: true)
//}

/// 隐藏键盘
func KeyboardHide() {
    UIApplication.shared.keyWindow?.endEditing(true)
}


/// 根据屏幕宽对尺寸进行伸缩
///
/// - Parameter f: 在375屏的尺寸
/// - Returns: 当前屏的尺寸
func Draw(f: CGFloat) -> CGFloat {
    return f * Wi / 375.0
}


#if DEBUG

func DLog(_ items: Any..., separator: String = " ", terminator: String = "\n") {
    print(items, separator: separator, terminator: terminator)
}

#else

func DLog(_ items: Any..., separator: String = " ", terminator: String = "\n") {}

#endif


/// 打电话
///
/// - Parameter phone: 电话号码
func Call(phone: String?) {
    if phone == nil  {
        DLog("号码为空")
        return
    }
    if phone!.count <= 2 {
        DLog("号码为空\(phone ?? "")")
        return
    }
    DLog("call:" + phone!)
    let phone = "telprompt://" + phone!
    if #available(iOS 10.0, *) {
        UIApplication.shared.open(URL(string: phone)!, options: [:], completionHandler: nil)
    } else {
        UIApplication.shared.openURL(URL(string: phone)!)
    }
    
}


/// 无网络
func NoNetwork() {
    if  UIViewController.topVC().isKind(of: UIAlertController.self) {
        return
    }
    let cont = UIAlertController.init(title: "网络异常", message: "请至设置>蜂窝移动网络中开启移动数据", preferredStyle: .alert)
    let alert1 = UIAlertAction.init(title: "取消", style: .default, handler: { (alert) in
        
    })
    let alert2 = UIAlertAction.init(title: "立即设置", style: .destructive, handler: { (alert) in
        let url = URL.init(string: UIApplication.openSettingsURLString)
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url!, options: [:], completionHandler: { (success) in
                DLog(success)
            })
        } else {
            UIApplication.shared.openURL(url!)
        }
    })
    cont.addAction(alert1)
    cont.addAction(alert2)
    UIViewController.topVC().present(cont, animated: true, completion: nil)
}



/// 跳转登录
/// - Parameter vc: 当前控制器
func ToLogin(vc: UIViewController) {
    
}
