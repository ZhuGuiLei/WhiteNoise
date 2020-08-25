//
//  MJRefreshFooter+NoData.swift
//  RealTimeBid
//
//  Created by apple on 2019/11/28.
//  Copyright © 2019 JAVIS. All rights reserved.
//

import Foundation
import MJRefresh

extension MJRefreshAutoStateFooter
{
    func endRefreshingNoMoreData() {
        if let vc = self.viewController() as? GLBasePageTableVC {
            if vc.dataArray.count > 0 {
                self.setTitle("┈┈┈┈┈┈    我是有底线的    ┈┈┈┈┈┈", for: .noMoreData)
            } else {
                self.setTitle(" ", for: .noMoreData)
            }
        }
        self.endRefreshingWithNoMoreData()
    }
}
