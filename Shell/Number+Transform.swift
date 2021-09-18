//
//  Number+Transform.swift
//  Kun
//
//  Created by 杨柳 on 2018/11/20.
//  Copyright © 2018年 com.kun. All rights reserved.
//

import Foundation

#if os(iOS)

import UIKit

#endif

// MARK: - Int
public extension Int {
    
    init(_ string: String?) {
        self = Int.init(string ?? "") ?? 0
    }
    
    init?(nil string: String?) {
        guard let stringSome = string else {
            return nil
        }
        guard let valueSome = Int.init(stringSome) else {
            return nil
        }
        
        self = valueSome
    }
    
}

// MARK: - Float
public extension Float {
    
    init(_ string: String?) {
        self = Float.init(string ?? "") ?? 0.0
    }
    
    init?(nil string: String?) {
        guard let stringSome = string else {
            return nil
        }
        guard let valueSome = Float.init(stringSome) else {
            return nil
        }
        
        self = valueSome
    }
    
    /// 保留 scale 位小数.
    /// - Parameters:
    ///   - scale: 需保留 scale 位小数.
    ///   - mode: up 向上取整, down 向下取整, plain 四舍五入. 默认 down.
    /// - Returns: 转换后.
    func transform(_ scale: Int, mode: NSDecimalNumber.RoundingMode = .down) -> Float {
        let new = Decimal(Double(self)).transform(scale: scale, mode: mode)
        
        return Float(truncating: new as NSDecimalNumber)
    }
    
}

// MARK: - Double
public extension Double {
    
    init(_ string: String?) {
        self = Double.init(string ?? "") ?? 0.0
    }
    
    init?(nil string: String?) {
        guard let stringSome = string else {
            return nil
        }
        guard let valueSome = Double.init(stringSome) else {
            return nil
        }
        
        self = valueSome
    }
    
    /// 保留 scale 位小数.
    /// - Parameters:
    ///   - scale: 需保留 scale 位小数.
    ///   - mode: up 向上取整, down 向下取整, plain 四舍五入. 默认 down.
    /// - Returns: 转换后.
    func transform(scale: Int, mode: NSDecimalNumber.RoundingMode = .down) -> Double {
        let new = Decimal(self).transform(scale: scale, mode: mode)
        
        return Double(truncating: new as NSDecimalNumber)
    }
    
    /// 格式化为价格 String, 向下保留两位小数 (1000.509 -> 1,000.50).
    func formatPrice() -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        
        let new = transform(scale: 2)
        return formatter.string(from: NSNumber(value: new)) ?? "0.00"
    }
    
}

// MARK: - Decimal
public extension Decimal {
    
    init(_ string: String?) {
        self = Decimal.init(string: string ?? "") ?? 0.0
    }
    
    init?(nil string: String?) {
        guard let stringSome = string else {
            return nil
        }
        guard let valueSome = Decimal.init(string :stringSome) else {
            return nil
        }
        
        self = valueSome
    }
    
    /// 保留 scale 位小数.
    /// - Parameters:
    ///   - scale: 需保留 scale 位小数.
    ///   - mode: up 向上取整, down 向下取整, plain 四舍五入. 默认 down.
    /// - Returns: 转换后.
    func transform(scale: Int, mode: NSDecimalNumber.RoundingMode = .down) -> Decimal {
        var raw = self
        var new = Decimal()
        
        NSDecimalRound(&new, &raw, scale, mode)
        
        return new
    }
    
}

// MARK: - CGFloat
public extension CGFloat {
    
    init(_ string: String?) {
        self = CGFloat.init(nil: string) ?? 0.0
    }
    
    init?(nil string: String?) {
        guard let valueSome = Double(nil: string) else {
            return nil
        }
        
        self = CGFloat(valueSome)
    }
    
    /// 保留 scale 位小数.
    /// - Parameters:
    ///   - scale: 需保留 scale 位小数.
    ///   - mode: up 向上取整, down 向下取整, plain 四舍五入. 默认 down.
    /// - Returns: 转换后.
    func transform(scale: Int, mode: NSDecimalNumber.RoundingMode = .down) -> CGFloat {
        let new = Decimal(Double(self)).transform(scale: scale, mode: mode)
        
        return CGFloat(truncating: new as NSDecimalNumber)
    }
    
}

// MARK: - CGPoint
public extension CGPoint {
    
    /// 保留 scale 位小数.
    /// - Parameters:
    ///   - scale: 需保留 scale 位小数.
    ///   - mode: up 向上取整, down 向下取整, plain 四舍五入. 默认 down.
    /// - Returns: 转换后.
    func transform(scale: Int, mode: NSDecimalNumber.RoundingMode = .down) -> CGPoint {
        return CGPoint(x: x.transform(scale: scale, mode: mode), y: y.transform(scale: scale, mode: mode))
    }
    
}

// MARK: - CGSize
public extension CGSize {
    
    /// 保留 scale 位小数.
    /// - Parameters:
    ///   - scale: 需保留 scale 位小数.
    ///   - mode: up 向上取整, down 向下取整, plain 四舍五入. 默认 down.
    /// - Returns: 转换后.
    func transform(scale: Int, mode: NSDecimalNumber.RoundingMode = .down) -> CGSize {
        return CGSize(width: width.transform(scale: scale, mode: mode), height: height.transform(scale: scale, mode: mode))
    }
    
}

// MARK: - CGRect
public extension CGRect {
    
    /// 保留 scale 位小数.
    /// - Parameters:
    ///   - scale: 需保留 scale 位小数.
    ///   - mode: up 向上取整, down 向下取整, plain 四舍五入. 默认 down.
    /// - Returns: 转换后.
    func transform(scale: Int, mode: NSDecimalNumber.RoundingMode = .down) -> CGRect {
        return CGRect(origin: origin.transform(scale: scale, mode: mode), size: size.transform(scale: scale, mode: mode))
    }
    
}

#if os(iOS)

// MARK: - UIEdgeInsets
public extension UIEdgeInsets {
    
    /// 保留 scale 位小数.
    /// - Parameters:
    ///   - scale: 需保留 scale 位小数.
    ///   - mode: up 向上取整, down 向下取整, plain 四舍五入. 默认 down.
    /// - Returns: 转换后.
    func transform(scale: Int, mode: NSDecimalNumber.RoundingMode = .down) -> UIEdgeInsets {
        return UIEdgeInsets(top: top.transform(scale: scale, mode: mode), left: left.transform(scale: scale, mode: mode), bottom: bottom.transform(scale: scale, mode: mode), right: right.transform(scale: scale, mode: mode))
    }
    
}

#endif
