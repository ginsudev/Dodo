//
//  Settings+Types.swift
//  
//
//  Created by Noah Little on 7/4/2023.
//

import SwiftUI

extension Settings {
    enum TimeMediaPlayerStyle: Int {
        case time
        case mediaPlayer
        case both
    }
    
    enum FontType: Int {
        case `default`
        case monospaced
        case rounded
        case serif
        
        var representedFont: Font.Design {
            switch self {
            case .default: return .default
            case .rounded: return .rounded
            case .monospaced: return .monospaced
            case .serif: return .serif
            }
        }
    }
    
    enum GridSizeType: Int {
        case flexible = 0
        case fixed = 1
        case adaptive = 2
    }
    
    enum MediaPlayerStyle: Int {
        case modular = 0
        case classic = 1
        
        var cornerRadius: CGFloat {
            switch self {
            case .modular:
                return UIDevice._hasHomeButton() ? 8.0 : 15.0
            case .classic:
                return 0.0
            }
        }
        
        var artworkRadius: CGFloat {
            switch self {
            case .modular:
                return cornerRadius - Dimensions.Padding.medium
            case .classic:
                return 5.0
            }
        }
    }
    
    enum StatusItem: CaseIterable, Identifiable {
        case lockIcon
        case seconds
        case chargingIcon
        case alarms
        case dnd
        case vibration
        case muted
        case flashlight
        
        var id: Self { self }

        var isEnabled: Bool {
            switch self {
            case .lockIcon: return PreferenceManager.shared.settings.hasLockIcon
            case .seconds: return PreferenceManager.shared.settings.hasSecondsIcon
            case .chargingIcon: return PreferenceManager.shared.settings.hasChargingIcon
            case .alarms: return PreferenceManager.shared.settings.hasAlarmIcon
            case .dnd: return PreferenceManager.shared.settings.hasDNDIcon
            case .vibration: return PreferenceManager.shared.settings.hasVibrationIcon
            case .muted: return PreferenceManager.shared.settings.hasMutedIcon
            case .flashlight: return PreferenceManager.shared.settings.hasFlashlightIcon
            }
        }
    }
}
