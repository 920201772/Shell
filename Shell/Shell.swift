//
//  Shell.swift
//  Shell
//
//  Created by 杨柳 on 2021/9/14.
//

import Foundation

public enum Shell {
    
    public static var environment: [String: String] { ProcessInfo.processInfo.environment }
    public static var currentPath: String {
        let arguments = ProcessInfo.processInfo.arguments
        let index = arguments.firstIndex(of: "-interpret")! + 1
        let paths = arguments[index].split(separator: "/")
        if paths.first != "." && paths.first != ".." {
            return arguments[index]
        }
        
        var pwd = environment["PWD"]!.split(separator: "/", omittingEmptySubsequences: false)
        paths.forEach {
            if $0 == ".." {
                pwd.removeLast()
            } else if $0 != "." {
                pwd.append($0)
            }
        }
        
        return pwd.joined(separator: "/")
    }
    public static var currentDirectory: String {
        currentPath.pathDirectory
    }
    
    @discardableResult
    public static func run(_ command: String) -> Result {
        let process = Process()
        process.executableURL = .init(fileURLWithPath: "/bin/sh")
        process.arguments = ["-c", command]
        
        let output = Pipe()
        let error = Pipe()
        process.standardOutput = output
        process.standardError = error
        
        try! process.run()

        let outputData = output.fileHandleForReading.readDataToEndOfFile()
        let errorData = error.fileHandleForReading.readDataToEndOfFile()
        let outputText = String(data: outputData, encoding: .utf8)!
        let errorText = String(data: errorData, encoding: .utf8)!
        
        process.waitUntilExit()
        
        return process.terminationStatus == 0 ? .success(outputText) : .failure(errorText)
    }
    
    public static func print(_ items: Any..., color: Int = 0, isEndColor: Bool = true, isNewline: Bool = true) {
        let text = items.reduce("") { $0.isEmpty ? "\($1)" : "\($0) \($1)" }
        var last = ""
        if isEndColor {
            last.append("\u{1B}[0m")
        }
        
        Swift.print("\u{1B}[\(color)m\(text)\(last)", terminator: isNewline ? "\n" : "")
    }
    public static func print(red items: Any..., isEndColor: Bool = true, isNewline: Bool = true) {
        let text = items.reduce("") { $0.isEmpty ? "\($1)" : "\($0) \($1)" }
        print(text, color: 31, isEndColor: isEndColor, isNewline: isNewline)
    }
    public static func print(green items: Any..., isEndColor: Bool = true, isNewline: Bool = true) {
        let text = items.reduce("") { $0.isEmpty ? "\($1)" : "\($0) \($1)" }
        print(text, color: 32, isEndColor: isEndColor, isNewline: isNewline)
    }
    public static func print(yellow items: Any..., isEndColor: Bool = true, isNewline: Bool = true) {
        let text = items.reduce("") { $0.isEmpty ? "\($1)" : "\($0) \($1)" }
        print(text, color: 33, isEndColor: isEndColor, isNewline: isNewline)
    }
    public static func print(blue items: Any..., isEndColor: Bool = true, isNewline: Bool = true) {
        let text = items.reduce("") { $0.isEmpty ? "\($1)" : "\($0) \($1)" }
        print(text, color: 34, isEndColor: isEndColor, isNewline: isNewline)
    }
    
}

// MARK: - Result
extension Shell {
    
    public enum Result {
        
        case success(String)
        case failure(String)
        
        public var isSuccess: Bool {
            if case .success = self {
                return true
            }
            
            return false
        }
        
        public var output: String? {
            if case let .success(text) = self {
                return text
            }
            
            return nil
        }
        
        public var error: String? {
            if case let .failure(text) = self {
                return text
            }
            
            return nil
        }
        
    }
    
}
