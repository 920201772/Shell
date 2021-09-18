//
//  QRCode.swift
//  Shell
//
//  Created by 杨柳 on 2021/9/17.
//

import Foundation
import CoreImage

public enum QRCode {
    
    public static func create(filePath: String, content: String, size: UInt) throws {
        let filter = CIFilter(name: "CIQRCodeGenerator")!
        filter.setValue(Data(content.utf8), forKey: "inputMessage")
        filter.setValue("H", forKey: "inputCorrectionLevel")
        
        let colorFilter = CIFilter(name: "CIFalseColor")!
        colorFilter.setValue(filter.outputImage, forKey: "inputImage")
        colorFilter.setValue(CIColor.black, forKey: "inputColor0")
        colorFilter.setValue(CIColor.white, forKey: "inputColor1")
        
        guard var image = colorFilter.outputImage else { throw Error.outputImage }
        
        let size = CGFloat(size)
        var scale = size / image.extent.width
        scale = (scale * image.extent.width).transform(scale: 0, mode: .plain) / image.extent.width
        image = image.transformed(by: .init(scaleX: scale, y: scale))
        
        let context = CIContext()
        guard let cgImage = context.createCGImage(image, from: image.extent) else { throw Error.createImage }
        
        guard let destination = CGImageDestinationCreateWithURL(URL(fileURLWithPath: filePath) as CFURL, kUTTypePNG, 1, nil) else {
            throw Error.url
        }
        CGImageDestinationAddImage(destination, cgImage, nil)
        CGImageDestinationFinalize(destination)
    }
    
}

// MARK: - QRCode
public extension QRCode {
    
    enum Error: LocalizedError {
        
        /// 输出二维码图片失败.
        case outputImage
        /// 创建图片失败.
        case createImage
        /// 无效的 URL.
        case url
        
        public var errorDescription: String? {
            switch self {
            case .url: return "无效的 URL."
            case .outputImage: return "输出二维码图片失败."
            case .createImage: return "创建图片失败."
            }
        }
        
    }
    
}
