//
//  ViewController.swift
//  RealTimeBid
//
//  Created by apple on 2020/6/1.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit
import MJRefresh

class BaseViewController: MainViewController {
    
    lazy var mj_imgArr: [UIImage] = {
        var imgArr = [UIImage].init()
        for item in 1...25 {
            if let img = UIImage.init(named: "图层 \(item)") {
                imgArr.append(img)
            }
        }
        return imgArr
    }()
    lazy var mj_header: MJRefreshGifHeader = {
        let header = MJRefreshGifHeader.init()
        header.lastUpdatedTimeLabel?.isHidden = false
        header.lastUpdatedTimeLabel?.font = UIFont.systemFont(ofSize: 11, weight: .medium)
        header.lastUpdatedTimeLabel?.textColor = .color(l: .w153, d: .w88)
        header.lastUpdatedTimeText = { (date) in
            
            if let time = date?.minuteDescription() {
                return "上次刷新\(time)"
            }
            return "上次刷新\(Date.init().minuteDescription())"
        }
        header.stateLabel?.font = UIFont.systemFont(ofSize: 11, weight: .medium)
        header.stateLabel?.textColor = .color(l: .w153, d: .w88)
        header.setTitle("松开立即刷新", for: .pulling)
        header.setTitle("刷新中...", for: .refreshing)
        header.setTitle("下拉可以刷新", for: .idle)
        
        
        header.gifView?.contentMode = .center
        header.gifView?.clipsToBounds = false
        header.setImages([UIImage.init(named: "图层")!], for: .pulling)
        header.setImages(mj_imgArr, duration: 0.8, for: .refreshing)
        header.setImages([UIImage.init(named: "图层")!], for: .idle)
        
        header.gifView?.snp.makeConstraints { (make) in
            make.width.height.equalTo(26)
            make.centerY.equalToSuperview()
            make.centerX.equalToSuperview().offset(-60)
        }
        header.stateLabel?.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview().offset(-8)
            make.centerX.equalToSuperview()
        }
        header.lastUpdatedTimeLabel?.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview().offset(8)
            make.centerX.equalToSuperview()
        }
        return header
    }()
    
    lazy var mj_footer: MJRefreshAutoGifFooter = {
        let footer = MJRefreshAutoGifFooter.init()
        
        //上拉加载更多数据
        footer.isRefreshingTitleHidden = false
        footer.stateLabel?.isHidden = false
        footer.stateLabel?.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        footer.stateLabel?.textColor = .color(l: .white(192), d: .w88)
        footer.setTitle("┈┈┈┈┈┈    我是有底线的    ┈┈┈┈┈┈", for: .noMoreData)
        footer.setTitle("数据加载中...", for: MJRefreshState.refreshing)
        footer.setTitle("", for: MJRefreshState.idle)
        
        
        footer.gifView?.contentMode = .center
        footer.gifView?.clipsToBounds = false
        footer.setImages([UIImage.init(named: "图层")!], for: .pulling)
        footer.setImages(mj_imgArr, duration: 0.8, for: .refreshing)
        footer.setImages([UIImage.init(named: "图层")!], for: .idle)
        
        footer.gifView?.snp.makeConstraints { (make) in
            make.width.height.equalTo(26)
            make.centerY.equalToSuperview()
            make.centerX.equalToSuperview().offset(-60)
        }
        footer.stateLabel?.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.centerX.equalToSuperview()
        }
        
        return footer
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        
    }
}

