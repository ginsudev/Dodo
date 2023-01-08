//
//  SuggestionView.ViewModel.swift
//  
//
//  Created by Noah Little on 29/12/2022.
//

import Foundation
import SwiftUI

extension SuggestionView {
    enum BluetoothButtonType {
        case icon
        case iconWithText
    }
    
    struct ViewModel {
        var appsManager = AppsManager.self
        
        var bluetoothColor: UIColor {
            if PreferenceManager.shared.settings.playerStyle == .classic {
                return UIImage(withBundleIdentifier: appsManager.suggestedAppBundleIdentifier).dominantColour().withAlphaComponent(0.3)
            } else {
                return .white
            }
        }
    }
}
