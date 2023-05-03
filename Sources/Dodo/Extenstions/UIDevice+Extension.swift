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
            return PreferenceManager.shared.settings.colors.batteryMinColor
        case 20..<80:
            return PreferenceManager.shared.settings.colors.batteryMidColor
        default:
            return PreferenceManager.shared.settings.colors.batteryMaxColor
        }
    }
}
