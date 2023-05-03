//
//  Settings+Types.swift
//  
//
//  Created by Noah Little on 7/4/2023.
//

import SwiftUI
import GSCore

extension Settings {
    struct Dimensions {
        let androBarHeight = AndroBar().barHeight
        let notificationVerticalOffset: Double
    }
    
    struct MediaPlayer {
        let timeMediaPlayerStyle: TimeMediaPlayerStyle
        let playerStyle: MediaPlayerStyle
        let showSuggestions: Bool
        let showDivider: Bool
        let isMarqueeLabels: Bool
        let themeName: String

        var themePath: String {
            "/Library/Application Support/Dodo/Themes/\(themeName)/".rootify
        }
    }
    
    struct Appearance {
        let selectedFont: FontType
        let timeFontSize: Double
        let dateFontSize: Double
        let weatherFontSize: Double
        let hasChargingFlash: Bool
    }
    
    struct TimeDate {
        let timeTemplate: DateTemplate
        let dateTemplate: DateTemplate
        let isEnabled24HourMode: Bool
    }
    
    struct FavouriteApps {
        let hasFavouriteApps: Bool
        let favouriteAppBundleIdentifiers: [String]
        let isVisibleFavouriteAppsFade: Bool
        let favouriteAppsGridSizeType: Settings.GridSizeType
        let favouriteAppsFlexibleGridItemSize: Double
        let favouriteAppsFlexibleGridColumnAmount: Int
        let favouriteAppsFixedGridItemSize: Double
        let favouriteAppsFixedGridColumnAmount: Int
    }
    
    struct Weather {
        let showWeather: Bool
        let isActiveWeatherAutomaticRefresh: Bool
    }
    
    struct StatusItems {
        let hasStatusItems: Bool
        let statusItemSize: CGSize
        let hasLockIcon: Bool
        let hasSecondsIcon: Bool
        let hasChargingIcon: Bool
        let hasAlarmIcon: Bool
        let hasDNDIcon: Bool
        let hasVibrationIcon: Bool
        let hasMutedIcon: Bool
        let hasFlashlightIcon: Bool
    }
    
    struct Colors {
        let timeColor: UIColor
        let dateColor: UIColor
        let dividerColor: UIColor
        let weatherColor: UIColor
        let lockIconColor: UIColor
        let alarmIconColor: UIColor
        let dndIconColor: UIColor
        let flashlightIconColor: UIColor
        let vibrationIconColor: UIColor
        let mutedIconColor: UIColor
        let secondsIconColor: UIColor
                
        /// Red
        static let batteryMinColor: UIColor = .systemRed
        /// Yellow
        static let batteryMidColor: UIColor = .systemYellow
        /// Green
        static let batteryMaxColor: UIColor = .systemGreen

    }
    
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
                return cornerRadius - Padding.medium
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
            let settings = PreferenceManager.shared.settings.statusItems
            switch self {
            case .lockIcon: return settings.hasLockIcon
            case .seconds: return settings.hasSecondsIcon
            case .chargingIcon: return settings.hasChargingIcon
            case .alarms: return settings.hasAlarmIcon
            case .dnd: return settings.hasDNDIcon
            case .vibration: return settings.hasVibrationIcon
            case .muted: return settings.hasMutedIcon
            case .flashlight: return settings.hasFlashlightIcon
            }
        }
    }
}
