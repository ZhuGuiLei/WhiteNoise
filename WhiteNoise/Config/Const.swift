//
//  Const.swift
//  RealTimeBid
//
//  Created by apple on 2020/6/1.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit
import AdSupport


let isDebug = true
//let isDebug = false

//微信
let WXAppID = "wxecd7abd9b78115ef"
let WXAppSecret = "13b29c83eb97b58de1d14c9d553602b8"
let WXUniversalLink = "https://raw.githubusercontent.com/ZhuGuiLei/GLMaze/master/apple-app-site-association/"

let AppId = "1525649368"
let AppStote = "itms-apps://itunes.apple.com/cn/app/id\(AppId)?mt=8"



/// 当前AppDelegate
var GLApp: AppDelegate? {
    get {
        if let app = UIApplication.shared.delegate as? AppDelegate {
            return app
        }
        return nil
    }
}

/// 主窗口
var GLWindow: UIWindow? {
    get{
        if let app = UIApplication.shared.delegate as? AppDelegate {
            return app.window
        }
        return nil
    }
}

/// 屏幕宽
let Wi: CGFloat = UIScreen.main.bounds.size.width

/// 屏幕高
let Hi: CGFloat = UIScreen.main.bounds.size.height

/// 状态栏高
let Hs: CGFloat = UIApplication.shared.statusBarFrame.size.height

/// 导航栏高
var Hn: CGFloat = Hs + 44


/// 下巴高
var Hb: CGFloat {
    get {
        if #available(iOS 11.0, *) {
            return UIApplication.shared.windows[0].safeAreaInsets.bottom
        } else {
            return 0
        }
    }
}

/// TabBar高
let Htb: CGFloat = 49 + Hb

/// 是否X系列
var IsPhoneX: Bool {
    get {
        if Hb > 0 {
            return true
        } else {
            return false
        }
    }
}

/// 屏幕 2、3倍屏
let ScreenScale: CGFloat = UIScreen.main.scale

let SafeSide = CGFloat(Wi >= 414 ? 20 : 16)


/// 类型别名
typealias BaseBlock = (() -> Void)
typealias BaseTypeBlock<T> = ((_ sender: T) -> Void)



struct AppInfo {
    
    static let infoDictionary = Bundle.main.infoDictionary
    
    static let appDisplayName: String? = Bundle.main.infoDictionary!["CFBundleDisplayName"] as? String //App 名称
    
    static let bundleIdentifier:String = Bundle.main.bundleIdentifier! // Bundle Identifier
    
    static let appVersion:String = Bundle.main.infoDictionary! ["CFBundleShortVersionString"] as! String// App 版本号
    
    static let buildVersion : String = Bundle.main.infoDictionary! ["CFBundleVersion"] as! String //Bulid 版本号
    
    static let iOSVersion:String = UIDevice.current.systemVersion //ios 版本
    
    static let identifierNumber = UIDevice.current.identifierForVendor?.uuidString //设备 udid
    
    static let identifierForAdvertising = ASIdentifierManager.shared().advertisingIdentifier.uuidString //广告标识
    
    static let systemName = UIDevice.current.systemName //设备名称
    
    static let systemVersion = UIDevice.current.systemVersion //设备名称
    
    static let model = UIDevice.current.model // 设备型号
    
    static let localizedModel = UIDevice.current.localizedModel  //设备区域化型号
    
    static let localLanguage = (UserDefaults.standard.object(forKey: "AppleLanguages") as! NSArray).object(at: 0)   //设备语言
    
    static var appIntVersion: Int {
        let arr = appVersion.components(separatedBy: ".")
        var v = 0
        for str in arr {
            v = v * 10 + (Int(str) ?? 0)
        }
        return v
    }
}

