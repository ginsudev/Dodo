//
//  UIDevice+Extension.swift
//  
//
//  Created by Noah Little on 11/1/2023.
//

import UIKit

extension UIDevice {
    func batteryLevelColorRepresentation() -> UIColor {
        switch (UIDevice.current.batteryLevel * 100) {
        case 0..<20:
            return .red
        case 20..<80:
            return .yellow
        default:
            return .green
        }
    }
}
