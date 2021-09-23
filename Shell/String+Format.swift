//
//  String+Format.swift
//  Kun
//
//  Created by 杨柳 on 2020/11/2.
//  Copyright © 2020 com.kun. All rights reserved.
//

import Foundation

public extension String {
    
    /// 格式化为储存单位, 基础单位 B.
    init(formatStorage size: Int) {
        if size >= 1_048_576_000 {
            self = .init(format: "%.2f GB", Double(size) / 1_073_741_824.0)
        } else if size >= 1_024_000 {
            self = .init(format: "%.2f MB", Double(size) / 1_048_576.0)
        } else if size >= 1_000 {
            self = .init(format: "%.2f KB", Double(size) / 1_024.0)
        } else {
            self = "\(size) B"
        }
    }
    
    /// 格式化时间.
    /// - Parameters:
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
    ///   - date: 需要格式化的名称.
    init(format: String, date: Date) {
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = format
        
        self = dateFormat.string(from: date)
    }

    /// 格式化间隔时间.
    /// - Parameters:
    ///   - fromDate: 开始日期.
    ///   - toDate: 目标日期.
    init(format fromDate: Date, to date: Date) {
        let components: Set<Calendar.Component> = [.year, .month, .day, .hour, .minute, .second]
        let calendar = Calendar.current
        let fromComponents = calendar.dateComponents(components, from: date)
        let toComponents = calendar.dateComponents(components, from: fromDate)
        
        if calendar.dateComponents([.second], from: fromComponents, to: toComponents).second! < 60 {
            self = "刚刚"
        }
        
        let minute = calendar.dateComponents([.minute], from: fromComponents, to: toComponents).minute!
        if minute < 60 {
            self = "\(minute) 分钟前"
        }
        
        let dateFormat = DateFormatter()
        
        if calendar.dateComponents([.hour], from: fromComponents, to: toComponents).hour! < 48 {
            let dayDifference = toComponents.day! - fromComponents.day!
            
            if dayDifference == 0 {
                dateFormat.dateFormat = "HH:mm"
                self = "今天 \(dateFormat.string(from: date))"
            }
            
            if dayDifference == 1 || dayDifference == -calendar.range(of: .day, in: .month, for: date)!.last! + 1 {
                dateFormat.dateFormat = "HH:mm"
                self = "昨天 \(dateFormat.string(from: date))"
            }
        }
        
        if toComponents.year! - fromComponents.year! == 0 {
            dateFormat.dateFormat = "MM-dd HH:mm"
            self = dateFormat.string(from: date)
        }
        
        dateFormat.dateFormat = "yyyy-MM-dd HH:mm"
        self = dateFormat.string(from: date)
    }
    
}
