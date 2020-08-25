//
//  MainViewController.swift
//  RealTimeBid
//
//  Created by apple on 2020/6/1.
//  Copyright © 2020 apple. All rights reserved.
//

import Foundation

enum HBDNavBarType {
    case white
    case main
    case clear
}

extension UIViewController
{
    
    func hbdNavBar(type: HBDNavBarType) {
        switch type {
            
        case .white:
            self.hbd_barTintColor = .color(l: .white, d: .w17)
            
            self.hbd_tintColor = .color(l: .w51, d: .w248)
            self.hbd_barAlpha = 1
            self.hbd_barShadowHidden = true
            
            var dic = [NSAttributedString.Key: Any]()
            dic[.foregroundColor] = UIColor.color(l: .white(51), d: .w248)
            dic[.font] = UIFont.systemFont(ofSize: 18)
            self.hbd_titleTextAttributes = dic
            
        case .main:
//            let color = UIColor.gradientColor(size: CGSize.init(width: Wi, height: Hn), direction: .level, startColor: .main, endColor: .main)
//            if IsPhoneX {
//                self.hbd_barImage = UIImage.init(asset: Asset.navBg1)
//            } else {
//                self.hbd_barImage = UIImage.init(asset: Asset.navBg)
//            }
            self.hbd_barTintColor = .main
            
            self.hbd_tintColor = .white
            self.hbd_barAlpha = 1
            self.hbd_barShadowHidden = true
            
            var dic = [NSAttributedString.Key: Any]()
            dic[.foregroundColor] = UIColor.white
            dic[.font] = UIFont.systemFont(ofSize: 18)
            self.hbd_titleTextAttributes = dic
            
        case .clear:
            self.hbd_barImage = UIImage.init()
            
            self.hbd_tintColor = .color(l: .w51, d: .w248)
            self.hbd_barAlpha = 0
            self.hbd_barShadowHidden = true
            
            var dic = [NSAttributedString.Key: Any]()
            dic[.foregroundColor] = UIColor.color(l: .white(51), d: .w248)
            dic[.font] = UIFont.systemFont(ofSize: 18)
            self.hbd_titleTextAttributes = dic
                        
        }
    }
}


// MARK: - 基础vc
class MainViewController: UIViewController {
    
    var hbdNavType: HBDNavBarType? {
        didSet {
            hbdNavBar(type: hbdNavType ?? .white)
        }
    }
    
    deinit {
        DLog("deinit:\(self)")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .color(l: .white, d: .rgb(17,17,24))
        self.automaticallyAdjustsScrollViewInsets = false
        
        if hbdNavType == nil && navigationController != nil {
            hbdNavType = .white
        }
    }
    
    func addTextFieldDidChangedNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(textFieldDidChanged), name: UITextField.textDidChangeNotification, object: nil)
    }
    
    @objc func textFieldDidChanged() {
        
    }
    
}

// MARK: - 状态栏和屏幕旋转
extension MainViewController
{
    override var childForStatusBarHidden: UIViewController? {
        return self.presentedViewController
    }
    
    override var childForStatusBarStyle: UIViewController? {
        return self.presentedViewController
    }
    /// 状态栏是否隐藏
    override var prefersStatusBarHidden: Bool
    {
        return self.presentedViewController?.prefersStatusBarHidden ?? false
    }
    
    /// 状态栏动画
    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation
    {
        return self.presentedViewController?.preferredStatusBarUpdateAnimation ?? .none
    }
    
    /// 状态栏的类型
    override var preferredStatusBarStyle: UIStatusBarStyle
    {
        return self.presentedViewController?.preferredStatusBarStyle ?? .default
    }
    
    /// 是否支持自动旋转
    override var shouldAutorotate: Bool {
        return self.presentedViewController?.shouldAutorotate ?? true
    }
    
    /// 支持的旋转方向
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return self.presentedViewController?.supportedInterfaceOrientations ?? .portrait
    }
}
