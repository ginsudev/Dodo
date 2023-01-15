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
        var suggestedAppIcon: UIImage {
            if let image = UIImage.image(forBundleIdentifier: AppsManager.shared.suggestedAppBundleIdentifier) {
                return image
            } else {
                if #available(iOS 15.0, *) {
                    return UIImage(systemName: "questionmark.app.fill")!
                } else {
                    return UIImage(systemName: "questionmark.square.fill")!
                }
            }
        }
        
        var bluetoothColor: UIColor {
            if PreferenceManager.shared.settings.playerStyle == .classic {
               return suggestedAppIcon.dominantColour().withAlphaComponent(0.3)
            } else {
                return .white
            }
        }
    }
}
