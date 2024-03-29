//
//  SuggestionView.ViewModel.swift
//  
//
//  Created by Noah Little on 29/12/2022.
//

import Foundation
import SwiftUI
import GSCore

extension SuggestionView {
    enum BluetoothButtonType {
        case icon
        case iconWithText
    }
    
    struct ViewModel {
        let settings = PreferenceManager.shared.settings

        var suggestedAppIcon: UIImage {
            if let image = UIImage.icon(bundleIdentifier: AppsManager.shared.suggestedAppBundleIdentifier) {
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
            if settings.mediaPlayer.playerStyle == .classic {
               return suggestedAppIcon.dominantColour().withAlphaComponent(0.3)
            } else {
                return .white
            }
        }
    }
}
