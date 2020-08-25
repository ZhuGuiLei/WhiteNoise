//
//  GLBasePageTableVC.swift
//  RealTimeBid
//
//  Created by apple on 2020/6/1.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit

class GLBasePageTableVC: GLBaseTableVC {

    var dataArray = NSMutableArray()
    var page = 1
    
    /// 总数的试图
    lazy var v_totalCount: UIView = {
        let view = UIView.init()
        view.backgroundColor = .rgb(209,225,255)
        let lab = UILabel.init()
        view.addSubview(lab)
        lab.snp.makeConstraints { (make) in
            make.centerX.centerY.equalToSuperview()
        }
        lab.font = .systemFont(ofSize: 11)
        lab.textColor = .main
        lab.tag = 901
        return view
    }()
    /// 总数
    var totalCount: Int = 0 {
        didSet {
            if totalCount > 0 {
                if let lab = v_totalCount.viewWithTag(901) as? UILabel {
                    lab.text = "已更新\(totalCount)条最新内容"
                    view.addSubview(v_totalCount)
                    v_totalCount.snp.remakeConstraints { (make) in
                        make.left.right.equalToSuperview()
                        make.top.equalTo(tableView)
                        make.height.equalTo(25)
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        UIView.animate(withDuration: 0.5, animations: {
                            self.v_totalCount.alpha = 0.2
                        }) { (completion) in
                            self.v_totalCount.removeFromSuperview()
                            self.v_totalCount.alpha = 1
                        }
                        
                    }
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        mj_header.setRefreshingTarget(self, refreshingAction: #selector(headerRefresh))
        tableView.mj_header = mj_header
        mj_footer.setRefreshingTarget(self, refreshingAction: #selector(footerRefresh))
        tableView.mj_footer = mj_footer
        
    }
    
    /// 设置空数据代理， 在第一次网络加载后设置
    func showEmptyData() {
        tableView.emptyDataSetSource = self
        tableView.emptyDataSetDelegate = self
    }
    
    /// 请求新的数据
    func requestNewData() {
        
    }
    /// 下拉刷新，自动滚动到顶部，结束界面编辑
    @objc func headerRefresh() {
        UIApplication.shared.keyWindow?.endEditing(true)
        page = 1
        requestNewData()
    }
    /// 下一页
    @objc func footerRefresh(){
        if dataArray.count > 0 {
            page +=  1
            requestNewData()
        } else {
            mj_footer.endRefreshing()
        }
    }
    /// 结束刷新，自动加载新数据
    func endRefresh(){
        showEmptyData()
        didSetDataArray()
        
        tableView.reloadData()
        mj_header.endRefreshing()
        mj_footer.endRefreshing()
        
    }
    
    /// 空数据时头部广告不显示
    func didSetDataArray() {
        
    }
    
    func show(totalCount count: Int?) {
        self.totalCount = count ?? 0
    }
    
}


extension GLBasePageTableVC: DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {

    func verticalOffset(forEmptyDataSet scrollView: UIScrollView!) -> CGFloat {
        return -20 - Hb
    }
    func spaceHeight(forEmptyDataSet scrollView: UIScrollView!) -> CGFloat {
        return 16
    }

//    func image(forEmptyDataSet scrollView: UIScrollView!) -> UIImage! {
//        return UIImage.init(asset: Asset.nodataSearch)
//    }

    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let title = NSMutableAttributedString(string: "暂未查找到相关信息")
        title.addAttributes([.font : UIFont.systemFont(ofSize: 15), .foregroundColor : UIColor.color(l: .w153, d: .w88)], range: NSRange.init(location: 0, length: title.string.count))
        return title
    }
    
//    func description(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
//        let title = NSMutableAttributedString(string: "搜索别的关键词试试")
//        title.addAttributes([.font : UIFont.systemFont(ofSize: 13), .foregroundColor : UIColor.color(l: .w153, d: .w88)], range: NSRange.init(location: 0, length: title.string.count))
//        return title
//    }

    func emptyDataSetShouldAllowScroll(_ scrollView: UIScrollView!) -> Bool {
        return true
    }

//    func emptyDataSetDidAppear(_ scrollView: UIScrollView!) {
//        let tit = scrollView.value(forKeyPath: "emptyDataSetView.titleLabel") as? UILabel
//        let detail = scrollView.value(forKeyPath: "emptyDataSetView.detailLabel") as? UILabel
//
//        detail?.snp.updateConstraints({ (make) in
//            make.centerX.equalToSuperview()
//            make.top.equalTo(tit!.snp.bottom).offset(8)
//        })
//    }
}
