//
//  GLBaseTableVC.swift
//  RealTimeBid
//
//  Created by apple on 2020/6/1.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit
import SnapKit

class GLBaseTableVC: BaseViewController {
    
    var style: UITableView.Style = .grouped
    
    lazy var tableView: UITableView = {
        
        let tableView = UITableView.init(frame: CGRect.zero, style: style)
        
        tableView.tableHeaderView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: 1, height: 5))
        tableView.tableFooterView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: 1, height: 0.01))
        tableView.sectionHeaderHeight = 5
        tableView.sectionFooterHeight = 0.01
        
        tableView.separatorStyle = .singleLine
        tableView.separatorInset = UIEdgeInsets.init(top: 0, left: SafeSide, bottom: 0, right: 0)
        tableView.separatorColor = .line
        
        tableView.estimatedRowHeight = 80
        tableView.rowHeight = UITableView.automaticDimension
        tableView.backgroundColor = .bgc_table
        tableView.keyboardDismissMode = .interactive
        
        tableView.showsHorizontalScrollIndicator = false
        tableView.showsVerticalScrollIndicator = true
        
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(tableView)
        
        tableView.snp.makeConstraints { (make) in
            make.left.top.right.bottom.equalToSuperview()
        }
        
        
    }
}

