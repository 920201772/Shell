//
//  Date+Format.swift
//  Kun
//
//  Created by 杨柳 on 2018/10/27.
//  Copyright © 2018年 com.kun. All rights reserved.
//

import Foundation

public extension Date {
    
    /// 字符串转换成时间.
    /// - Parameters:
    ///   - string: 字符串.
    ///   - format:
    ///     - zzz：3 个字母表示的时区 (如 GMT).
    ///     - yyyy：4 个数字表示的年.
    ///     - MMMM：月份的全写 (如 October).
    ///     - EEEE：表示星期几 (如 Monday).
    ///     - dd：表示一个月里面日期的数字.
    ///     - hh：2 个数字表示的小时 (大写为 24 小时制).
    ///     - mm：2 个数字表示的分钟.
    ///     - ss：2 个数字表示的秒.
    ///     - SSS 显示秒的小数部分.
    ///     - a 显示上下午.
    init?(_ string: String, format: String) {
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = format
        
        guard let date = dateFormat.date(from: string) else { return nil }
        
        self = date
    }
    
    /// 格式化时间.
    /// - Parameter format:
    ///     - zzz：3 个字母表示的时区 (如 GMT).
    ///     - yyyy：4 个数字表示的年.
    ///     - MMMM：月份的全写 (如 October).
    ///     - EEEE：表示星期几 (如 Monday).
    ///     - dd：表示一个月里面日期的数字.
    ///     - hh：2 个数字表示的小时 (大写为 24 小时制).
    ///     - mm：2 个数字表示的分钟.
    ///     - ss：2 个数字表示的秒.
    ///     - SSS 显示秒的小数部分.
    ///     - a 显示上下午.
    /// - Returns: 格式化时间.
    func format(_ format: String) -> String {
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = format
        
        return dateFormat.string(from: self)
    }
    
    /// 增加天数.
    /// - Parameter day: 需要增加的天数.
    /// - Returns: 增加后时间.
    func advanced(day: Int) -> Date {
        self + .init(86_400 * day)
    }
    
    /// 间隔时间.
    /// - Parameters:
    ///   - date: 比较的日期.
    ///   - components: 计算的组件.
    /// - Returns: DateComponents.
    func distance(to date: Date, components: Set<Calendar.Component>) -> DateComponents {
        Calendar.current.dateComponents(components, from: self, to: date)
    }
    
    /// 格式化间隔时间.
    /// - Parameter date: 比较的日期, 默认当前日期.
    /// - Returns: 格式化间隔时间.
    func distanceFormat(to date: Date = Date()) -> String {
        let components: Set<Calendar.Component> = [.year, .month, .day, .hour, .minute, .second]
        let calendar = Calendar.current
        let fromComponents = calendar.dateComponents(components, from: self)
        let toComponents = calendar.dateComponents(components, from: date)
        
        if calendar.dateComponents([.second], from: fromComponents, to: toComponents).second! < 60 {
            return "刚刚"
        }
        
        let minute = calendar.dateComponents([.minute], from: fromComponents, to: toComponents).minute!
        if minute < 60 {
            return "\(minute) 分钟前"
        }
        
        let dateFormat = DateFormatter()
        
        if calendar.dateComponents([.hour], from: fromComponents, to: toComponents).hour! < 48 {
            let dayDifference = toComponents.day! - fromComponents.day!
            
            if dayDifference == 0 {
                dateFormat.dateFormat = "HH:mm"
                return "今天 \(dateFormat.string(from: self))"
            }
            
            if dayDifference == 1 || dayDifference == -calendar.range(of: .day, in: .month, for: self)!.last! + 1 {
                dateFormat.dateFormat = "HH:mm"
                return "昨天 \(dateFormat.string(from: self))"
            }
        }
        
        if toComponents.year! - fromComponents.year! == 0 {
            dateFormat.dateFormat = "MM-dd HH:mm"
            return dateFormat.string(from: self)
        }
        
        dateFormat.dateFormat = "yyyy-MM-dd HH:mm"
        return dateFormat.string(from: self)
    }
    
}
