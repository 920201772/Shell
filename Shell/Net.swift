//
//  Net.swift
//  Shell
//
//  Created by 杨柳 on 2021/9/16.
//

import Foundation

public enum Net {
    
    public enum Error: LocalizedError {
        
        /// 无效的 URL.
        case url
        
        public var errorDescription: String? {
            switch self {
            case .url: return "无效的 URL."
            }
        }
        
    }
    
}

// MARK: - HTTP
public extension Net {
    
    enum HTTP {
        
        public static func post(path: String, header: [String: String] = ["Content-Type": "application/json"], parameters: [String: Any] = [:]) throws -> JSON {
            try request(path: path, header: header, parameters: parameters, method: .post)
        }
        
        public static func get(path: String, parameters: [String: Any] = [:]) throws -> JSON {
            var url = URLComponents(string: path)
            url?.queryItems = parameters.map {
                .init(name: $0.key, value: "\($0.value)")
            }
            guard let newPath = url?.string else { throw Error.url }
            
            return try request(path: newPath, header: [:], parameters: [:], method: .get)
        }
        
        public static func upload(multipart path: String, fileKey: String, filePath: String, parameters: [String: Any] = [:]) throws -> JSON {
            guard let url = URL(string: path) else { throw Error.url }
            let fileURL = URL(fileURLWithPath: filePath)
            let boundary = "Shell.boundary.\(UUID().uuidString)"
            
            let file = "--\(boundary)\r\nContent-Disposition: form-data; name=\"\(fileKey)\"; filename=\"\(fileURL.lastPathComponent)\"\r\nContent-Type: \(getMIMEType(pathExtension: fileURL.pathExtension))\r\n\r\n"
            
            var bodyData = Data(file.utf8)
            bodyData.append(try Data(contentsOf: fileURL))
            
            parameters.forEach {
                let parameter = "\r\n--\(boundary)\r\nContent-Disposition: form-data; name=\"\($0.key)\"\r\n\r\n\($0.value)"
                bodyData.append(contentsOf: parameter.utf8)
            }
            
            bodyData.append(contentsOf: "\r\n--\(boundary)--\r\n".utf8)
            
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.allHTTPHeaderFields = ["Content-Type": "multipart/form-data; boundary=\(boundary)"]
            
            var data: Data?
            var error: Swift.Error?
            let semaphore = DispatchSemaphore(value: 0)
            
            URLSession.shared.uploadTask(with: request, from: bodyData) {
                data = $0
                error = $2
                semaphore.signal()
            }.resume()

            semaphore.wait()

            if let error = error {
                throw error
            }
            
            let raw = try JSONSerialization.jsonObject(with: data ?? .init())
            
            return .init(raw: raw)
        }
        
        private static func request(path: String, header: [String: String], parameters: [String: Any], method: Method) throws -> JSON {
            guard let url = URL(string: path) else { throw Error.url }
            var request = URLRequest(url: url)
            request.httpMethod = method.rawValue
            request.allHTTPHeaderFields = header
            if !header.isEmpty {
                request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: [])
            }
            
            
            var data: Data?
            var error: Swift.Error?
            let semaphore = DispatchSemaphore(value: 0)
            
            URLSession.shared.dataTask(with: request) {
                data = $0
                error = $2
                semaphore.signal()
            }.resume()
            
            semaphore.wait()
            
            if let error = error {
                throw error
            }
            
            let raw = try JSONSerialization.jsonObject(with: data ?? .init())
            
            return .init(raw: raw)
        }
        
        private static func getMIMEType(pathExtension: String) -> String {
            if let tag = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, pathExtension as CFString, nil)?.takeRetainedValue(),
               let mimeType = UTTypeCopyPreferredTagWithClass(tag, kUTTagClassMIMEType)?.takeRetainedValue() {
                return mimeType as String
            }
            
            return "application/octet-stream"
        }
        
        public struct JSON {
            
            public var raw: Any
            
            public subscript(keys: String) -> Any? {
                var current = raw
                for key in keys.split(separator: ".") {
                    if let index = Int(key) {
                        if let value = current as? [Any] {
                            if (0..<value.count).contains(index) {
                                current = value[index]
                                continue
                            }
                        }
                        
                        return nil
                    } else {
                        if let value = current as? [String: Any] {
                            if let element = value[String(key)] {
                                current = element
                                continue
                            }
                        }
                        
                        return nil
                    }
                }
                
                return current
            }
            
        }
        
        private enum Method: String {
            
            case get = "GET"
            case post = "POST"
            
        }
        
    }
    
}
