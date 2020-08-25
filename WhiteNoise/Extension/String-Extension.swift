//
//  File.swift
//  RealTimeBid
//
//  Created by JAVIS on 2019/9/2.
//  Copyright © 2019 JAVIS. All rights reserved.
//

import Foundation

extension String {
    
    func imageTextWithWord(image: UIImage?, heightOffset: Double = -4, size: CGSize = .init(width: 39, height: 19), word: String? = nil) -> NSMutableAttributedString
    {
        let att = (" " + self).highlighted(word)
        
        let imageAttach = NSTextAttachment()
        imageAttach.image = image
        imageAttach.bounds = CGRect(origin: CGPoint(x: 0.0, y: heightOffset), size: size)
        let imageText = NSAttributedString(attachment: imageAttach)
        att.insert(imageText, at: 0)
        
        let paragraphStyle = NSMutableParagraphStyle.init()
        paragraphStyle.lineSpacing = 4
        paragraphStyle.lineBreakMode = .byTruncatingTail
        att.addAttribute(.paragraphStyle, value: paragraphStyle, range: NSRange.init(location: 0, length: att.length))
        
        return att
    }
    
    
    func redWord(word: String?) -> NSMutableAttributedString
    {
        let att = self.highlighted(word)
        
        let paragraphStyle = NSMutableParagraphStyle.init()
        paragraphStyle.lineSpacing = 4
        paragraphStyle.lineBreakMode = .byTruncatingTail
        att.addAttribute(.paragraphStyle, value: paragraphStyle, range: NSRange.init(location: 0, length: att.length))
        
        return att
    }
    
    func highlighted(_ word: String?) -> NSMutableAttributedString {
        let att = NSMutableAttributedString.init(string: self)
        
        if (word ?? "").isEmpty {
            return att
        }
        for item in 0..<self.count {
            let sub = self[item..<item+1]
            if word?.contains(sub) == true {
                att.addAttribute(.foregroundColor, value: UIColor.main, range: NSRange.init(location: item, length: 1))
            }
        }
        return att
    }
    
    
    func highlighted2(_ word: String?) -> NSMutableAttributedString {
        let att = NSMutableAttributedString.init(string: self)
        
        if (word ?? "").isEmpty {
            return att
        }
        
        let originText = NSString.init(string: self)
        att.addAttribute(.foregroundColor, value: UIColor.main, range: originText.localizedStandardRange(of: word!))
        return att
        
    }
    
}




extension NSAttributedString
{
    func redWords(_ words: [String]?) -> NSAttributedString {
        
        if (words ?? []).count <= 0 {
            return self
        }
        let mainStr = NSMutableAttributedString.init(attributedString: self)
        for word in words! {
            mainStr.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.main, range: NSString(string: self.string).localizedStandardRange(of: word))
        }
        return mainStr
    }
    
    
    func highlighted(_ word: String?) -> NSAttributedString {
        
        if (word ?? "").isEmpty {
            return self
        }
        let att = NSMutableAttributedString.init(attributedString: self)
        
        let originText = NSString.init(string: self.string)
        att.addAttribute(.foregroundColor, value: UIColor.main, range: originText.localizedStandardRange(of: word!))
        return att
        
    }
    
    
}

extension String
{
    /// 转化电话
    func toHiddenPhone() -> String {
        if self.count < 7 {
            return self
        }
        return self[0..<3] + "*****" + self[self.count-4..<self.count]
    }
}
