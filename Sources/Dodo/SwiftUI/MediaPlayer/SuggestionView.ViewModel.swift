//
//  SuggestionView.ViewModel.swift
//  
//
//  Created by Noah Little on 29/12/2022.
//

import Foundation
import SwiftUI

extension SuggestionView {
    enum TextType {
        case recommended
        case bluetooth
        case tap
    }
    
    struct ViewModel {
        var appsManager = AppsManager.self
        
        var bluetoothColor: UIColor {
            if PreferenceManager.shared.settings.playerStyle == .classic {
                return UIImage(withBundleIdentifier: appsManager.suggestedAppBundleIdentifier).dominantColour().withAlphaComponent(0.3)
            }
            return .white
        }
        
        func text(for type: TextType) -> String {
            switch type {
            case .recommended:
                return ResourceBundle.localisation(for: "Recommended_For_You")
            case .bluetooth:
                return ResourceBundle.localisation(for: "Bluetooth")
            case .tap:
                return ResourceBundle.localisation(for: "Tap_To_Listen")
            }
        }
    }
}
