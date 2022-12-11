//
//  UIImage+Icon.swift
//  
//
//  Created by Noah Little on 21/7/2022.
//

import UIKit
import DodoC

extension UIImage {
    convenience init!(withBundleIdentifier identifier: String?) {
        let icon: SBIcon? = SBIconController.sharedInstance().model.expectedIcon(forDisplayIdentifier: identifier)
        
        let imageSize = CGSize(width: 60, height: 60)
        
        let imageInfo = SBIconImageInfo(
            size: imageSize,
            scale: UIScreen.main.scale,
            continuousCornerRadius: 12
        )
        
        guard let image = icon?.generateImage(with: imageInfo) as? UIImage else {
            self.init()
            return
        }
        
        guard let data = image.pngData() else {
            self.init()
            return
        }
        
        self.init(data: data)
    }
    
    public func dominantColour() -> UIColor {
        guard let inputImage = CIImage(image: self) else {
            return .black
        }
        
        let extentVector = CIVector(
            x: inputImage.extent.origin.x,
            y: inputImage.extent.origin.y,
            z: inputImage.extent.size.width,
            w: inputImage.extent.size.height
        )
        
        let filter = CIFilter(
            name: "CIAreaAverage",
            parameters: [
                kCIInputImageKey: inputImage,
                kCIInputExtentKey: extentVector
            ]
        )!
        
        let outputImage = filter.outputImage!
        var bitmap = [UInt8](repeating: 0, count: 4)
        
        let context = CIContext(options: [.workingColorSpace: kCFNull!])
        context.render(
            outputImage,
            toBitmap: &bitmap,
            rowBytes: 4,
            bounds: CGRect(
                x: 0,
                y: 0,
                width: 1,
                height: 1
            ),
            format: .RGBA8,
            colorSpace: nil
        )
        
        return UIColor(
            red: CGFloat(bitmap[0]) / 255,
            green: CGFloat(bitmap[1]) / 255,
            blue: CGFloat(bitmap[2]) / 255,
            alpha: 1.0
        )
    }
}
