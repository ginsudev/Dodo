//
//  UIColor+Extension.swift
//  
//
//  Created by Noah Little on 23/7/2022.
//

import UIKit

extension UIColor {
    convenience init(hexString: String) {
        var hex = hexString.replacingOccurrences(of: "#", with: "").uppercased()
        
        if hex.contains(":") || hex.count == 6 {
            let colourComponents = hex.components(separatedBy: ":")
            let alpha: Float = colourComponents.count == 2 ? Float(colourComponents.last!)! / 100 : 1.0
            hex = "\(colourComponents.first!)\(Int(alpha * 255.0))"
        }
        
        var hexV: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&hexV)
        
        let r: CGFloat = CGFloat(((hexV & 0xFF000000) >> 24)) / 255.0
        let g: CGFloat = CGFloat(((hexV & 0x00FF0000) >> 16)) / 255.0
        let b: CGFloat = CGFloat(((hexV & 0x0000FF00) >> 8)) / 255.0
        let a: CGFloat = CGFloat(((hexV & 0x000000FF) >> 0)) / 255.0
        
        self.init(red: r, green: g, blue: b, alpha: a)
    }
    
    public func suitableForegroundColour() -> UIColor {
        isLight() ? .black : .white
    }
    
    private func isLight() -> Bool {
        let originalCGColor = self.cgColor
        let RGBCGColor = originalCGColor.converted(
            to: CGColorSpaceCreateDeviceRGB(),
            intent: .defaultIntent,
            options: nil
        )!
        let components = RGBCGColor.components!
        guard components.count >= 3 else {
            return false
        }
        let brightness = Float(((components[0] * 299) + (components[1] * 587) + (components[2] * 114)) / 1000)
        return (brightness > 0.7)
    }
}
