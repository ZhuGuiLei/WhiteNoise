//
//  RTDataSource.swift
//  RealTimeBid
//
//  Created by apple on 2020/6/3.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper

class RTDataSource: NSObject {
    
    static let shared = RTDataSource()
    
    private override init() {}
        
    var token: String? {
        get {
            return UserDefaults.standard.object(forKey: "token") as? String
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "token")
            if !(newValue ?? "").isEmpty {
                NotificationCenter.default.post(name: .init(Noti_User_Info_refresh), object: nil)
            }
        }
    }
    
//    var token: String?
    var umDeviceToken: String = ""
    
    
//    var initModel: RTInitModel?
    
    //暂无
    var domainPerfix: String {
        get {
            // FIXME: 请求端口
            if isDebug {
                //                return "http://23db4z.natappfree.cc/"
                return "http://58.218.201.79:60056/"
            }
            return "http://app.zboem.321194.com/"
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "domain")
        }
    }
    
    
    var areaArry: [String] = []//省份
    var areaDic: [String: [String]] = [:]
    
    var bidMoneyArray: [String] = ["全部金额"]
    var bidTypeArray: [String] = ["全部类型"]
    var bidTimeArray: [String] = ["全部时间"]
    var bidMoneyDic: [String: String] = [:]
    var bidTypeDic: [String: String] = [:]
    var bidTimeDic: [String: String] = [:]
    
    var buildingProjectArray: [String] = ["全部类型"]
    var buildingApprovalArray: [String] = ["全部类型"]
    var buildingTimeArray: [String] = ["全部时间"]
    var buildingProjectDic: [String: String] = [:]
    var buildingApprovalDic: [String: String] = [:]
    var buildingTimeDic: [String: String] = [:]
    
    var winMoneyArray: [String] = ["全部金额"]
    var winTimeArray: [String] = ["全部时间"]
    var winPhoneArray: [String] = ["全部", "有电话", "无电话"]
    var winMoneyDic: [String: String] = [:]
    var winTimeDic: [String: String] = [:]
    var winPhoneDic: [String: String] = ["全部": "0", "有电话": "1", "无电话": "2"]
    
    var issuedCategoryArray: [String] = ["全部"]
    var issuedTypeArray: [String] = ["全部类型"]
    var issuedTypeDic: [String: String] = ["全部类型": "0"]
    
    
    let userAges = ["", "20岁以内", "20-29岁", "30-39岁", "40-49岁", "50岁以上"]
    let userSexs = ["", "男", "女"]
    
    
}

//账户相关
extension RTDataSource {
    
    open func getUUID() -> String {
        if KeychainWrapper.standard.string(forKey: "uuid") == nil {
            KeychainWrapper.standard.set(NSUUID.init().uuidString, forKey: "uuid")
        }
        return KeychainWrapper.standard.string(forKey: "uuid") ?? ""
    }
}

