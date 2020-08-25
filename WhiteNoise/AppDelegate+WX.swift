//
//  AppDelegate+WX.swift
//  WhiteNoise
//
//  Created by apple on 2020/8/25.
//  Copyright © 2020 layne_zhu. All rights reserved.
//

import UIKit

extension AppDelegate: WXApiDelegate {
    
    func wx_register() {
        // 在register之前打开log, 后续可以根据log排查问题
        WXApi.startLog(by: WXLogLevel.normal) { (log) in
            DLog("wx-\(log)")
        }
        
        // 务必在调用自检函数前注册
        WXApi.registerApp(WXAppID, universalLink: WXUniversalLink)
        
        // 调用自检函数
        WXApi.checkUniversalLinkReady { (step: WXULCheckStep, result: WXCheckULStepResult) in
            DLog("wx--\(step.rawValue)   \(result.success)    \(result.errorInfo)    \(result.suggestion)")
        }
    }
    
    /// 第三方向微信终端发送一个SendAuthReq消息结构
    func wx_sendAuthRequest() {
        let req = SendAuthReq.init()
        req.scope = "snsapi_userinfo"
        req.state = "123"
        WXApi.send(req) { (finish) in
            
        }
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        return WXApi.handleOpen(url, delegate: self)
    }

    
    
    // MARK: - WXApiDelegate
    /// 收到一个来自微信的请求，第三方应用程序处理完后调用sendResp向微信发送结果
    /// - Parameter req: 具体请求内容，是自动释放的
    func onReq(_ req: BaseReq) {
        print(req)
    }
    
    /// 发送一个sendReq后，收到微信的回应
    /// - Parameter resp: 具体的回应内容，是自动释放的
    func onResp(_ resp: BaseResp) {
        print(resp)
    }

}
