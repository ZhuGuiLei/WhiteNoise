//
//  WNNetwork.swift
//  WhiteNoise
//
//  Created by apple on 2020/8/25.
//  Copyright © 2020 layne_zhu. All rights reserved.
//

import UIKit
import HandyJSON
import Alamofire
import SwiftyJSON


func API(_ url: String) -> String {
    return RTDataSource.shared.domainPerfix + url
}


/// 数据请求时的屏幕提示
///
/// - none: 没有屏幕提示
/// - indicator: 显示菊花
/// - failMsg: 显示错误信息
/// - indicatorAndFailMsg: 显示菊花和错误信息
enum RequestProgressHUD: Int8 {
    case none = 0b00
    case indicator = 0b01
    case failMsg = 0b10
    case indicatorAndFailMsg = 0b11
}


/// 网络配置单例类
class GLNetManager: SessionManager {
    
    private static var theManager: GLNetManager?
    
    static func shared(timeOutFlo: TimeInterval = 60) -> GLNetManager {
        
        let config = Config.shared()
        config.timeoutIntervalForRequest = timeOutFlo
        
        if theManager == nil{
            theManager = GLNetManager.init(configuration: config)
        }

        return theManager!
    }
    
}

/// 网络配置单例类
class Config: URLSessionConfiguration {
    private static var theConfig: URLSessionConfiguration?
    static func shared() -> URLSessionConfiguration {
        if theConfig == nil {
            theConfig = URLSessionConfiguration.default
        }
        return theConfig!
    }
}



class WNNetwork: NSObject {
    
    static private var isFirst: Bool = true //是否是第一次点击“确定”按钮
    
    static let secuKey = "lj%&#@.DFWEez3sd**3*@!@##..v#"
    
    // MARK: - 数据请求
    /// 数据请求
    ///
    /// - Parameters:
    ///   - method: 请求方式 .get; .post，默认post
    ///   - encoding: 编码方式，默认URLEncoding
    ///   - show: 屏幕提示，默认不提示none
    ///   - url: 请求地址
    ///   - params: 参数
    ///   - success: 成功回调
    ///   - fail: 请求结束回调
    static func request<T: BaseModel>(_ method: HTTPMethod = .post, encoding: ParameterEncoding = URLEncoding.default, show: RequestProgressHUD = .none, url: String, params: [String: Any]?, success: @escaping (_ result: T) -> Void, fail: @escaping (_ code: Int?, _ msg: String?, _ err: NSError?) -> Void) {
        /// 是否显示菊花
        if (show.rawValue & 0b01) == 0b01 {
            GLProgressHUD.showIndicator()
        }
        
        var hurl = url
        if !hurl.hasPrefix("http") {
            hurl = API(hurl)
        }
        
//        var signParam = params
//        if signParam != nil {
//            signParam!["sign"] = getSignStr(signParam!)
//        }
        
        let dataRequest = GLNetManager.shared().request(hurl, method: method, parameters: params, encoding: encoding, headers: getHeaderSign())
        // 相应
        dataRequest.responseJSON { (response: DataResponse<Any>) in
            
            self.responseJSON(response, show: show, success: { (result: T) in
                success(result)
            }) { (code, msg, err) in
                fail(code, msg, err)
            }
            
        }
    }
    
    
    /// 上传文件
    /// - Parameters:
    ///   - method: 请求方式 .get; .post，默认post
    ///   - show: 屏幕提示，默认不提示none
    ///   - url: 请求地址
    ///   - params: 参数
    ///   - data: 上传数据
    ///   - success: 成功回调
    ///   - fail: 请求结束回调
    static func upLoad<T: BaseModel>(_ method: HTTPMethod = .post, show: RequestProgressHUD = .none, url: String, params: [String: Any]?, data: [Data], success: @escaping (_ result: T) -> Void, fail: @escaping (_ code: Int?, _ msg: String?, _ err: NSError?) -> Void) {
        
        /// 是否显示菊花
        if (show.rawValue & 0b01) == 0b01 {
            GLProgressHUD.showIndicator()
        }
        
        var hurl = url
        if !hurl.hasPrefix("http") {
            hurl = API(hurl)
        }
        
        
        GLNetManager.shared().upload(multipartFormData: { (multipartFormData) in
            for i in 0..<data.count {
                
                if let name = params?["name"] as? String {
                    multipartFormData.append(data[i], withName:"file", fileName: name, mimeType: params?["type"] as? String ?? "pdf")
                } else {
                    var name = "ios_upload\(NSDate().timeIntervalSince1970)_\(arc4random())"
                    name = name.replacingOccurrences(of: ".", with: "") + ".jpg"
                    multipartFormData.append(data[i], withName:"file", fileName: name, mimeType: "image/jpg/png/jpeg")
                }
            }
        }, usingThreshold: SessionManager.multipartFormDataEncodingMemoryThreshold, to: hurl, method: method, headers: getHeaderSign()) { (encodingResult) in
            switch encodingResult {
            case .success(let uploadRequest, _, _):
                // 相应
                uploadRequest.responseJSON(completionHandler: { response in
                    
                    self.responseJSON(response, show: show, success: { (result: T) in
                        success(result)
                    }) { (code, msg, err) in
                        fail(code, msg, err)
                    }
                    
                })
                
                // 获取上传进度
                uploadRequest.uploadProgress(queue: DispatchQueue.global(qos: .utility)) { progress in
                    print("图片上传进度: \(progress.fractionCompleted)")
                }
             case .failure(let err):
                fail(-1, err.localizedDescription, nil)
            }
        }
    }
    
    
    /// 相应处理
    /// - Parameters:
    ///   - response: 相应结果
    private static func responseString<T: BaseModel>(_ response: DataResponse<String>, show: RequestProgressHUD = .none, success: @escaping (_ result: T) -> Void, fail: @escaping (_ code: Int?, _ msg: String?, _ err: NSError?) -> Void) {
        // 隐藏菊花
        if (show.rawValue & 0b01) == 0b01 {
            GLProgressHUD.dismissOne()
        }
        
        if response.result.isSuccess {
            if let value = response.result.value {
                if let model = JSONDeserializer<T>.deserializeFrom(json: value) {
                    if model.code == 0 {
                        success(model)
                    } else {
                        /// 是否显示错误信息
                        if (show.rawValue & 0b10) == 0b10 {
                            GLProgressHUD.showError(msg: model.msg)
                        }
                        fail(model.code, model.msg, nil)
                    }
                } else {
                    fail(-1, value, nil)
                }
            } else {
                /// 是否显示错误信息
                if (show.rawValue & 0b10) == 0b10 {
                    GLProgressHUD.showError(msg: "没有获取到数据")
                }
                // 没有获取到数据
                fail(-2, "没有获取到数据", nil)
            }
        } else {
            // 网络请求失败
            fail(-3, "网络请求失败", nil)
        }
    }
    
    /// 相应处理
    /// - Parameters:
    ///   - response: 相应结果
    private static func responseJSON<T: BaseModel>(_ response: DataResponse<Any>, show: RequestProgressHUD = .none, success: @escaping (_ result: T) -> Void, fail: @escaping (_ code: Int?, _ msg: String?, _ err: NSError?) -> Void) {
        // 隐藏菊花
        if (show.rawValue & 0b01) == 0b01 {
            GLProgressHUD.dismissOne()
        }
        
        if response.result.isSuccess {
            if let value = response.result.value as? [String: Any] {
                if let model = JSONDeserializer<T>.deserializeFrom(dict: value) {
                    if model.code == 0 {
                        success(model)
                    } else {
                        /// 是否显示错误信息
                        if (show.rawValue & 0b10) == 0b10 {
                            GLProgressHUD.showError(msg: model.msg)
                        }
                        fail(model.code, model.msg, nil)
                    }
                } else {
                    fail(-1, nil, nil)
                }
            } else {
                /// 是否显示错误信息
                if (show.rawValue & 0b10) == 0b10 {
                    GLProgressHUD.showError(msg: "没有获取到数据")
                }
                // 没有获取到数据
                fail(-2, "没有获取到数据", nil)
            }
        } else {
            // 网络请求失败
            fail(-3, "网络请求失败", nil)
        }
    }
    
    
    
    private static func getHeaderSign() -> HTTPHeaders {
        let tokenid = RTDataSource.shared.token ?? ""
        
        let prefix = "platform=ios" + "&" + "token-id=\(tokenid)" + "&" + "device-id=\(RTDataSource.shared.getUUID())" + "&" + "time=\(getCurrentStamp())" + "&" + "version=\(AppInfo.appVersion)" + "&" + "version-int=\(AppInfo.buildVersion)" + "&" + "channel=appstore" + "&" + "user-type=2" + "&" + "um-token=\(RTDataSource.shared.umDeviceToken)" + "&idfa=\(AppInfo.identifierForAdvertising)"
        
        let sign = CustomKeyChain.md5String(prefix + secuKey)
        
        let header = ["platform": "ios", "token-id": tokenid, "device-id": RTDataSource.shared.getUUID(), "time": "\(getCurrentStamp())", "version": AppInfo.appVersion, "version-int": AppInfo.buildVersion, "channel": "appstore", "user-type": "2", "um-token": RTDataSource.shared.umDeviceToken, "app-sign": sign!, "idfa": AppInfo.identifierForAdvertising]
        
        return header as HTTPHeaders
    }

    
    private static func getCurrentStamp() -> Int{
        let timeInterval: TimeInterval = Date.timeIntervalSinceReferenceDate
        let timeStamp = Int(timeInterval)
        return timeStamp
    }
    

    private static func getSignStr(_ params: [String: Any]) -> String? {
        let sortParams = params.sorted{$0.0 < $1.0}
        
        var signStr = ""
        for (paramKey, paramValue) in sortParams {
            signStr += "\(paramKey)=\(paramValue)&"
        }
        
        if signStr.count > 1 {
            signStr.removeLast()
        }
        return CustomKeyChain.md5String(signStr + secuKey)
    }
    
    
    
}
