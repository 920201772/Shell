//
//  Date+Extension.swift
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
    
}
