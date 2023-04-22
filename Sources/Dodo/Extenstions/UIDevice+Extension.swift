//
//  UIDevice+Extension.swift
//  
//
//  Created by Noah Little on 11/1/2023.
//

import UIKit

extension UIDevice {
    var batteryLevelColorRepresentation: UIColor {
        switch (self.batteryLevel * 100) {
        case 0..<20:
            return Colors.batteryMinColor
        case 20..<80:
            return Colors.batteryMidColor
        default:
            return Colors.batteryMaxColor
        }
    }
}
