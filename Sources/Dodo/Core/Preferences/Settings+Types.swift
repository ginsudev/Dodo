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
        let notificationVerticalOffset: Double
        let androBarHeight: CGFloat = AndroBar().isInstalledAndEnabled
        ? AndroBar().barHeight
        : 0
    }
    
    struct MediaPlayer {
        let timeMediaPlayerStyle: TimeMediaPlayerStyle
        let playerStyle: MediaPlayerStyle
        let showSuggestions: Bool
        let showDivider: Bool
        let isMarqueeLabels: Bool
        let themeName: String
        let isEnabledMediaBackdrop: Bool
        
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
        let isVisibleWhenDisabled: Bool
        let statusItemSize: CGSize
        let hasLockIcon: Bool
        let hasSecondsIcon: Bool
        let hasChargingIcon: Bool
        let hasAlarmIcon: Bool
        let hasDNDIcon: Bool
        let hasVibrationIcon: Bool
        let hasMutedIcon: Bool
        let hasFlashlightIcon: Bool
        let hasTimerIcon: Bool
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
        let timerIconColor: UIColor
                
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
        enum PresentationMode {
            case persistent
            case visibleWhenEnabled
            case visible
        }
        
        case lockIcon
        case seconds
        case chargingIcon
        case alarms
        case timer
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
            case .timer: return settings.hasTimerIcon
            }
        }
        
        var enabledImageName: String? {
            switch self {
            case .lockIcon: return "lock.fill"
            case .seconds: return nil
            case .chargingIcon: return nil
            case .alarms: return "alarm.fill"
            case .dnd: return "moon.fill"
            case .vibration:
                if #available(iOS 15, *) {
                    return "iphone.radiowaves.left.and.right.circle.fill"
                } else {
                    return "waveform.circle.fill"
                }
            case .muted: return "bell.slash.fill"
            case .flashlight: return "flashlight.on.fill"
            case .timer: return "timer"
            }
        }
        
        var disabledImageName: String? {
            switch self {
            case .lockIcon: return "lock.open.fill"
            case .seconds: return nil
            case .chargingIcon: return nil
            case .alarms: return enabledImageName
            case .dnd: return enabledImageName
            case .vibration: return enabledImageName
            case .muted: return "bell.fill"
            case .flashlight: return "flashlight.off.fill"
            case .timer: return enabledImageName
            }
        }
        
        var enabledColor: UIColor? {
            let colors = PreferenceManager.shared.settings.colors
            switch self {
            case .lockIcon: return colors.lockIconColor
            case .seconds: return colors.secondsIconColor
            case .chargingIcon: return nil // Determined in `StatusItemGroupView.ViewModel`
            case .alarms: return colors.alarmIconColor
            case .dnd: return colors.dndIconColor
            case .vibration: return colors.vibrationIconColor
            case .muted: return colors.mutedIconColor
            case .flashlight: return colors.flashlightIconColor
            case .timer: return colors.timerIconColor
            }
        }
        
        var disabledColor: UIColor? {
            switch self {
            case .lockIcon,
                 .seconds,
                 .chargingIcon,
                 .muted,
                 .flashlight:
                return enabledColor
            case .alarms, .dnd, .vibration, .timer:
                return enabledColor?.withAlphaComponent(0.4)
            }
        }
        
        var presentationMode: PresentationMode {
            switch self {
            case .lockIcon,
                 .seconds,
                 .flashlight:
                return .persistent
            case .alarms,
                .dnd,
                .vibration,
                .muted,
                .timer:
                return .visible
            case .chargingIcon:
                return .visibleWhenEnabled
            }
        }
        
        func isVisible(isStatusEnabled: Bool) -> Bool {
            switch presentationMode {
            case .persistent:
                return true
            case .visibleWhenEnabled:
                return isStatusEnabled
            case .visible:
                return isStatusEnabled || PreferenceManager.shared.settings.statusItems.isVisibleWhenDisabled
            }
        }
    }
}
