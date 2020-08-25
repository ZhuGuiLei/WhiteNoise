//
//  GLScrollView.swift
//  RealTimeBid
//
//  Created by apple on 2020/6/8.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit


protocol GLScrollViewDelegate: NSObjectProtocol {
    func glScrollViewDidScroll(scrollView: UIScrollView)
}

extension GLScrollViewDelegate {
    func glScrollViewDidScroll(scrollView: UIScrollView) {}
}


class GLScrollView: UIScrollView, UIGestureRecognizerDelegate {

    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        self.showsHorizontalScrollIndicator = false
        self.showsVerticalScrollIndicator = false
    }
}
