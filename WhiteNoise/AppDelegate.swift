//
//  AppDelegate.swift
//  WhiteNoise
//
//  Created by 朱桂磊 on 2020/8/24.
//  Copyright © 2020 layne_zhu. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        window = UIWindow.init(frame: UIScreen.main.bounds)
        window?.backgroundColor = .white
        window?.makeKeyAndVisible()
        
        let vc = WNHomeVC.init()
        let nav = MainNavController.init(rootViewController: vc)
        
        window?.rootViewController = nav
        
        wx_register()
        
        return true
    }

}

