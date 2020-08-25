//
//  String+GL.swift
//  RealTimeBid
//
//  Created by apple on 2019/10/30.
//  Copyright © 2019 JAVIS. All rights reserved.
//

extension String
{
    /// 长度
    var length: Int {
        return self.count
    }
    ///
    subscript (i: Int) -> String {
        return self[i ..< i + 1]
    }
    
    func substring(fromIndex: Int) -> String {
        return self[min(fromIndex, length) ..< length]
    }
    
    func substring(toIndex: Int) -> String {
        return self[0 ..< max(0, toIndex)]
    }
    
    subscript (r: Range<Int>) -> String {
        let range = Range(uncheckedBounds: (lower: max(0, min(length, r.lowerBound)), upper: min(length, max(0, r.upperBound))))
        let start = index(startIndex, offsetBy: range.lowerBound)
        let end = index(start, offsetBy: range.upperBound - range.lowerBound)
        return String(self[start ..< end])
    }
}

extension String {
    /// 获取Label的高
    func height(font: UIFont, width: CGFloat) -> CGFloat {
        let size = CGSize(width: width, height: CGFloat(MAXFLOAT))
        let strSize = self.boundingRect(with: size, options: [.usesLineFragmentOrigin], attributes: [NSAttributedString.Key.font: font], context: nil).size
        return CGFloat(ceilf(Float(strSize.height)))
    }

    /// 获取Label的宽
    public func width(font: UIFont) -> CGFloat {
        let size = CGSize(width: CGFloat(MAXFLOAT), height: 20)
        let strSize = self.boundingRect(with: size, options: [.usesLineFragmentOrigin], attributes: [NSAttributedString.Key.font: font], context: nil).size
        return CGFloat(ceilf(Float(strSize.width)))
    }

}

extension String {
    /// 手机验证
    func isPhoneNumber() -> Bool {
        if self.count == 0 {
            return false
        }
        let mobile = "^1[0-9]\\d{9}$"
        let regexMobile = NSPredicate(format: "SELF MATCHES %@",mobile)
        return regexMobile.evaluate(with: self)
    }
    
    /// 手机验证
    func isNumber() -> Bool {
        if self.count == 0 {
            return false
        }
        let mobile = "^[0-9.-]+$"
        let regexMobile = NSPredicate(format: "SELF MATCHES %@",mobile)
        return regexMobile.evaluate(with: self)
    }
    
    
    /// 邮箱验证
    func isEmail() -> Bool {
        if self.count == 0 {
            return false
        }
        let mobile = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        let regexMobile = NSPredicate(format: "SELF MATCHES %@",mobile)
        return regexMobile.evaluate(with: self)
    }
}

extension String
{
    /// 保留指定小数位，保留数字后的文字
    ///
    /// - Parameter decimal: 保留位数
    /// - Returns: 指定位数的小数字符串
    func toFloatStr(decimal: Int) -> String {
        // "686.076.5kahf.hfo"
        var a = ""
        var b = ""
        for c in self {
            if (c >= "0" && c <= "9") || c == "." {
                a.append(c)
            } else {
                b = self.substring(fromIndex: a.count)
                break
            }
            
        }
        // a = 686.076.5; b = kahf.hfo"
        let arr = a.components(separatedBy: ".")
        if arr.count == 0 {
            return "" + b
        } else if arr.count == 1 {
            return arr[0] + b
        } else {
            var xiaoshu = arr[1]
            if xiaoshu.count > decimal {
                xiaoshu = xiaoshu.substring(toIndex: decimal)
            }
            a = arr[0] + "." + xiaoshu
            return a + b
        }
    }
}

extension String
{
    func intValue() -> Int {
        return Int(NSString.init(string: self).integerValue)
//        let d = Double(self) ?? 0.0
//        return Int(d)
    }
}
