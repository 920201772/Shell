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
        
        guard let colorSpace = CGColorSpace(name: CGColorSpace.sRGB) else { throw Error.sRGB }
        try CIContext().writePNGRepresentation(of: image, to: .init(fileURLWithPath: filePath), format: .RGBA8, colorSpace: colorSpace, options: [:])
    }
    
}

// MARK: - QRCode
public extension QRCode {
    
    enum Error: LocalizedError {
        
        /// 输出二维码图片失败.
        case outputImage
        /// 找不到 sRGB 颜色空间.
        case sRGB
        
        public var errorDescription: String? {
            switch self {
            case .outputImage: return "输出二维码图片失败."
            case .sRGB: return "找不到 sRGB 颜色空间."
            }
        }
        
    }
    
}
