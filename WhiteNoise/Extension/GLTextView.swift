//
//  EVTextView.swift
//  RealTimeBid
//
//  Created by apple on 2019/11/9.
//  Copyright © 2019 JAVIS. All rights reserved.
//

import UIKit

protocol GLTextViewDelegate: NSObjectProtocol {
    func textViewDidBeginEditing(_ textView: GLTextView)
    func textViewDidEndEditing(_ textView: GLTextView)
    func textViewDidChange(_ textView: GLTextView)
    func textViewShouldReturn(_ textView: GLTextView)
}
extension GLTextViewDelegate
{
    func textViewDidBeginEditing(_ textView: GLTextView) {}
    func textViewDidEndEditing(_ textView: GLTextView) {}
    func textViewDidChange(_ textView: GLTextView) {}
    func textViewShouldReturn(_ textView: GLTextView) {}
}

class GLTextView: UITextView, UITextViewDelegate {

    weak var rtdelegate: GLTextViewDelegate?
    
    var rttext: String! {
        get {
            return text
        }
        set {
            text = newValue
            textViewDidChange(self)
        }
    }
    
    
    private var l_placeholder = UILabel.init()
    private var l_textCount = UILabel.init()
    
    @IBInspectable var placeholder: String? {
        get {
            return l_placeholder.text
        }
        set {
            l_placeholder.text = newValue
        }
    }
    
    var placeholderAttributedText: NSAttributedString? {
        get {
            return l_placeholder.attributedText
        }
        set {
            l_placeholder.attributedText = newValue
        }
    }

    
    /// 不限制输入数量
    @IBInspectable var maxCount: Int = Int(INT16_MAX) {
        didSet {
            textViewDidChange(self)
        }
    }
    
    override func didMoveToSuperview() {
        
        if self.superview == nil {
            return
        }
        self.showsVerticalScrollIndicator = false
        self.showsHorizontalScrollIndicator = false
        
        self.delegate = self
        
        self.subviews.first?.clipsToBounds = true
        
        l_textCount.font = UIFont.systemFont(ofSize: 12)
        l_textCount.textColor = .color(l: .w153, d: .whiteAlpha(0.4))
        
        l_textCount.removeFromSuperview()
        self.superview!.addSubview(l_textCount)
        l_textCount.snp.remakeConstraints { (make) in
            make.right.equalTo(self)
            make.bottom.equalTo(self)
        }
        
        l_placeholder.textColor = .color(l: .w153, d: .whiteAlpha(0.4))
        l_placeholder.removeFromSuperview()
        self.superview!.addSubview(l_placeholder)
        l_placeholder.snp.remakeConstraints { (make) in
            make.left.equalTo(self).offset(4)
            make.top.equalTo(self).offset(6)
        }
        
    }
    
    func textViewDidChange(_ textView: UITextView) {
        if textView.returnKeyType == .done || textView.returnKeyType == .send {
            if textView.text.last == "\n" {
                textView.text.removeLast()
                textView.resignFirstResponder()
            }
        }
        l_placeholder.isHidden = !textView.text.isEmpty
        
        if textView.text.count > maxCount {
            let start = textView.text.startIndex
            let end = textView.text.index(start, offsetBy: maxCount)
            textView.text = String(textView.text[start ..< end])
        }
        
        l_textCount.text = "\(textView.text.count)/\(maxCount)"
        
        self.rtdelegate?.textViewDidChange(self)
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        if textView.returnKeyType == .done || textView.returnKeyType == .send {
            if text == "\n" {
                self.rtdelegate?.textViewShouldReturn(self)
                textView.resignFirstResponder()
                return false
            }
        }
        return true
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        self.rtdelegate?.textViewDidBeginEditing(self)
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        self.rtdelegate?.textViewDidEndEditing(self)
    }
    
    override func layoutSubviews() {
        l_placeholder.font = self.font
        
        if maxCount != INT16_MAX {
            self.contentInset = UIEdgeInsets.init(top: 0, left: 0, bottom: 15, right: 0)
            l_textCount.isHidden = false
        } else {
            self.contentInset = UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 0)
            l_textCount.isHidden = true
        }
        
    }
    
    deinit {
        DLog("deinit:\(self)")
    }
    
}
