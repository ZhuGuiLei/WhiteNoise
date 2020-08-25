//
//  ACLabelCounting.swift
//  ACLabelCounting
//
//  Created by acumen on 17/2/16.
//  Copyright © 2017年 acumen. All rights reserved.
//

import UIKit

let countRate = 35

enum ACLabelCountingAnimationType {
    case None
    case Liner
    case EaseIn
    case EaseOut
    case EaseInOut
}

enum ACLabelCountingDataType {
    case Int
    case Double
}

class ACLabelCounting: UILabel {
    
    private var progress: Double = 0
    private var dataType: ACLabelCountingDataType = .Int
    private var animationType: ACLabelCountingAnimationType = .None
    private var duration: TimeInterval = 2
    private var displayLink: CADisplayLink? = CADisplayLink()
    private var lastUpdate: TimeInterval = Date.timeIntervalSinceReferenceDate
    
    // number
    private var startValue: Double = 0
    private var endValue: Double = 0
    
    // closure
    private var formatTextClosure: ((String) -> String) = { text -> String in return text }
    private var attributedTextClosure: ((String) -> NSAttributedString)?
    
    @objc private func updateNumber(value: TimeInterval) {
        let now = Date.timeIntervalSinceReferenceDate
        progress += Double(now - self.lastUpdate)
        self.lastUpdate = now
        
        let scale = renderScale(type: animationType)
        accumulation(text: (endValue - startValue) * scale + startValue)
    }
    
    private func accumulation(text: Double) {
        let txt = handleText(with: text, type: dataType)
        if let closure = attributedTextClosure {
            self.attributedText = closure(txt)
        } else {
            self.text = formatTextClosure(txt)
        }
        
        if progress >= duration {
            if let closure = attributedTextClosure {
                self.attributedText = closure(handleText(with: endValue, type: dataType))
            } else {
                self.text = formatTextClosure(handleText(with: endValue, type: dataType))
            }
            self.invalidateDisplayLink()
        }
    }
    
    private func invalidateDisplayLink() {
        if displayLink != nil {
            displayLink!.remove(from: RunLoop.main, forMode: RunLoop.Mode.common)
            displayLink!.invalidate()
            displayLink = nil
        }
    }
    
    private func fireDisplayLink() {
        lastUpdate = Date.timeIntervalSinceReferenceDate
        displayLink = CADisplayLink(target: self, selector: #selector(updateNumber))
        if #available(iOS 10, *) {
            displayLink!.preferredFramesPerSecond = countRate
        } else {
            displayLink!.frameInterval = countRate / 35
        }
        displayLink!.add(to: RunLoop.main, forMode: RunLoop.Mode.common)
    }
    
    /// 数字转字符串
    private func handleText(with: Double, type: ACLabelCountingDataType) -> String {
        switch type {
        case .Int:
            return String(format: "%.0lf", with)
        default:
            return String(format: "%.2lf", with)
        }
    }
    
    /// 数字变化规律
    private func renderScale(type: ACLabelCountingAnimationType) -> Double {
        switch type {
        case .None:
            return liner(progress: progress, totle: Double(duration))
        case .EaseIn:
            return easeIn(progress: progress, totle: Double(duration))
        case .EaseOut:
            return easeOut(progress: progress, totle: Double(duration))
        case .EaseInOut:
            return easeInOut(progress: progress, totle: Double(duration))
        default:
            return liner(progress: progress, totle: Double(duration))
        }
    }
    
    private func initText(value: Double) {
        accumulation(text: value)
    }
    
    /// publish method
    /// 暂停
    func pause() {
        invalidateDisplayLink()
    }
    
    /// 恢复
    func restore() {
        self.lastUpdate = Date.timeIntervalSinceReferenceDate
        fireDisplayLink()
    }
    
    /// 开始
    func start() {
        fireDisplayLink()
    }
    
    /// 暂停
    func stop() {
        invalidateDisplayLink()
    }
    
    /// 重置
    func reset() {
        invalidateDisplayLink()
        if let closure = attributedTextClosure {
            count(from: startValue,
                  to: endValue,
                  duration: duration,
                  animationType: animationType,
                  dataType: dataType,
                  attributedTextClosure: closure)
        } else {
            count(from: startValue,
                  to: endValue,
                  duration: duration,
                  animationType: animationType,
                  dataType: dataType,
                  formatTextClosure: formatTextClosure)
        }
    }
    
    func count(from fromValue: Double = 0.0,
               to toValue: Double,
               duration time: TimeInterval = 2,
               animationType: ACLabelCountingAnimationType = .None,
               dataType: ACLabelCountingDataType = .Int,
               formatTextClosure: @escaping (String) -> String = { text -> String in return text }) {
        
        assert((fromValue >= 0 && toValue >= 0), "the fromValue or toValue must be not negative!")
        
        progress = 0
        self.dataType = dataType
        self.formatTextClosure = formatTextClosure
        self.startValue = fromValue
        self.endValue = toValue
        self.animationType = animationType
        self.duration = time
        
        initText(value: startValue)
    }
    
    func count(from fromValue: Double = 0.0,
               to toValue: Double,
               duration time: TimeInterval = 2,
               animationType: ACLabelCountingAnimationType = .None,
               dataType: ACLabelCountingDataType = .Int,
               attributedTextClosure: @escaping (String) -> NSAttributedString) {
        
        self.attributedTextClosure = attributedTextClosure
        count(from: fromValue,
              to: toValue,
              duration: time,
              animationType: animationType,
              dataType: dataType)
    }
}

extension ACLabelCounting {
    func liner(progress: Double, totle: Double) -> Double {
        return progress / totle
    }
    
    /// 先慢后快
    func easeIn(progress: Double, totle: Double) -> Double {
        /// 计算以x为底数的y次幂
        return pow(progress / totle, 3)
    }
    /// 先快后慢
    func easeOut(progress: Double, totle: Double) -> Double {
        let t = progress / totle
        return  1 - pow(1 - t, 3)
    }
    
    /// 慢-快-慢
    func easeInOut(progress: Double, totle: Double) -> Double {
        let t = progress / totle
        return t < 0.5 ? 4 * pow(t, 3) : (t - 1) * (2 * t - 2) * (2 * t - 2) + 1
    }
}
