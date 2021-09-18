//
//  Regular.swift
//  Kun
//
//  Created by 杨柳 on 2021/8/12.
//  Copyright © 2021 com.kun. All rights reserved.
//

import Foundation

public final class Regular: ExpressibleByStringLiteral {
    
    private let expression: NSRegularExpression
    
    public init(_ string: String) throws {
        expression = try NSRegularExpression(pattern: string)
    }
    
    /// 非法正则字符串的话会崩溃.
    public convenience init(stringLiteral value: String) {
        try! self.init(value)
    }
    
}

// MARK: - Method
public extension Regular {
    
    /// 验证是否符合正则.
    func verify(_ string: String) -> Bool {
        let result = expression.matches(in: string, range: NSRange(location: 0, length: string.count))
        return !result.isEmpty
    }
    
}

// MARK: - 常用
public extension Regular {
    
    /// 手机号码.
    static var mobileNumber: Self { #"^1(3|4|5|6|7|8|9)\d{9}$"# }
    /// 中文.
    static var chinese: Self { #"^[\u4E00-\u9FA5]{0,}$"# }
    /// 银行卡号.
    static var bankCardNumber: Self { #"^(\d{16}|\d{19})$"# }
    /// 邮箱.
    static var email: Self { #"^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,4}"# }
    /// 身份证 15 位.
    static var identifyFifteen: Self { #"^[1-9]\d{7}((0\d)|(1[0-2]))(([0|1|2]\d)|3[0-1])\d{3}$"# }
    /// 身份证 18 位.
    static var identifyEighteen: Self { #"^[1-9]\d{5}[1-9]\d{3}((0\d)|(1[0-2]))(([0|1|2]\d)|3[0-1])\d{3}([0-9]|X)$"# }
    /// IP.
    static var ip: Self { #"^((2[0-4]\d|25[0-5]|[1]?\d\d?)\.){3}(2[0-4]\d|25[0-5]|[1]?\d\d?)$"# }
    /// 端口.
    static var port: Self { #"^[0-9]$|(^[1-9][0-9]$)|(^[1-9][0-9][0-9]$)|(^[1-9][0-9][0-9][0-9]$)|(^[1-6][0-5][0-5][0-3][0-5]$)"# }
    
    /// 数字, 中文, 字母.
    convenience init(numberAndCharacter range: ClosedRange<Int>) {
        self.init(stringLiteral: "^[\\u4E00-\\u9FA5a-zA-Z0-9]{\(range.lowerBound),\(range.upperBound)}$")
    }
    
}

// MARK: - String
public extension String {
    
    /// 验证是否符合正则.
    func verify(regular: Regular) -> Bool {
        regular.verify(self)
    }
    
}
