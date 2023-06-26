//
//  PreferenceManager.swift
//  
//
//  Created by Noah Little on 14/12/2022.
//

import Foundation
import SwiftUI
import Comet
import GSCore

final class PreferenceManager {
    static let shared = PreferenceManager()
    
    var settings: Settings {
        underlyingSettings
    }
    
    private var underlyingSettings: Settings!
    private let notificationBridge = NotificationBridge()
    let defaults = UserDefaults.standard
    
    func loadSettings(withDictionary dict: [String: Any]) {
        self.underlyingSettings = .init(withDictionary: dict)
    }
}

struct Settings {
    let isEnabled: Bool
    let dimensions: Dimensions
    let mediaPlayer: MediaPlayer
    let appearance: Appearance
    let timeDate: TimeDate
    let favouriteApps: FavouriteApps
    let weather: Weather
    let statusItems: StatusItems
    let colors: Colors
    
    init(withDictionary dict: [String: Any]) {
        isEnabled = dict["isEnabled"] as? Bool ?? true
        dimensions = .init(notificationVerticalOffset: dict["notificationVerticalOffset"] as? Double ?? 190.0)
        
        mediaPlayer = .init(
            timeMediaPlayerStyle: TimeMediaPlayerStyle(rawValue: dict["timeMediaPlayerStyle"] as? Int ?? 2)!,
            playerStyle: MediaPlayerStyle(rawValue: dict["playerStyle"] as? Int ?? 0)!,
            showSuggestions: dict["showSuggestions"] as? Bool ?? true,
            showDivider: dict["showDivider"] as? Bool ?? true,
            isMarqueeLabels: dict["isMarqueeLabels"] as? Bool ?? false,
            themeName: dict["themeName"] as? String ?? "Rounded",
            isEnabledMediaBackdrop: dict["isEnabledMediaBackdrop"] as? Bool ?? true
        )
        
        appearance = .init(
            selectedFont: FontType(rawValue: dict["selectedFont"] as? Int ?? 0)!,
            timeFontSize: dict["timeFontSize"] as? Double ?? 50.0,
            dateFontSize: dict["dateFontSize"] as? Double ?? 15.0,
            weatherFontSize: dict["weatherFontSize"] as? Double ?? 15.0,
            hasChargingFlash: dict["hasChargingFlash"] as? Bool ?? false
        )
        
        let timeTemplate: DateTemplate = {
            switch dict["timeTemplate"] as? Int ?? 0 {
            case 0:
                return .time
            case 1:
                return .timeWithSeconds
            case 2:
                return .timeCustom(dict["timeTemplateCustomFormat"] as? String ?? "h:mm")
            default:
                return .time
            }
        }()
        
        let dateTemplate: DateTemplate = {
            switch dict["dateTemplate"] as? Int ?? 0 {
            case 0:
                return .date
            case 1:
                return .dateCustom(dict["dateTemplateCustomFormat"] as? String ?? "EEEE, MMMM d")
            default:
                return .date
            }
        }()
        
        timeDate = .init(
            timeTemplate: timeTemplate,
            dateTemplate: dateTemplate,
            isEnabled24HourMode: dict["isEnabled24HourMode"] as? Bool ?? false
        )

        favouriteApps = .init(
            hasFavouriteApps: dict["hasFavouriteApps"] as? Bool ?? true,
            favouriteAppBundleIdentifiers: dict["selectedFavouriteApps"] as? [String] ?? [
                "com.apple.camera",
                "com.apple.Preferences",
                "com.apple.MobileSMS",
                "com.apple.mobilemail"
            ],
            isVisibleFavouriteAppsFade: dict["isVisibleFavouriteAppsFade"] as? Bool ?? false,
            favouriteAppsGridSizeType: GridSizeType(rawValue: dict["favouriteAppsGridSizeType"] as? Int ?? 0)!,
            favouriteAppsFlexibleGridItemSize: dict["favouriteAppsFlexibleGridItemSize"] as? Double ?? 40.0,
            favouriteAppsFlexibleGridColumnAmount: dict["favouriteAppsFlexibleGridColumnAmount"] as? Int ?? 3,
            favouriteAppsFixedGridItemSize: dict["favouriteAppsFixedGridItemSize"] as? Double ?? 40.0,
            favouriteAppsFixedGridColumnAmount: dict["favouriteAppsFixedGridColumnAmount"] as? Int ?? 3
        )
        
        weather = .init(
            showWeather: dict["showWeather"] as? Bool ?? true,
            isActiveWeatherAutomaticRefresh: dict["isActiveWeatherAutomaticRefresh"] as? Bool ?? true,
            tapAction: WeatherTapAction(rawValue: dict["weatherTapAction"] as? Int ?? 0)!,
            isVisibleHighLow: dict["isVisibleHighLow"] as? Bool ?? false,
            isVisibleSunriseSunset: dict["isVisibleSunriseSunset"] as? Bool ?? false
        )
        
        let itemSize = dict["indicatorSize"] as? Double ?? 18.0
        statusItems = .init(
            hasStatusItems: dict["hasStatusItems"] as? Bool ?? true,
            isVisibleWhenDisabled: dict["isVisibleWhenDisabled"] as? Bool ?? false,
            statusItemSize: .init(width: itemSize, height: itemSize),
            hasLockIcon: dict["hasLockIcon"] as? Bool ?? true,
            hasSecondsIcon: dict["hasSecondsIcon"] as? Bool ?? true,
            hasChargingIcon: dict["hasChargingIcon"] as? Bool ?? true,
            hasAlarmIcon: dict["hasAlarmIcon"] as? Bool ?? true,
            hasDNDIcon: dict["hasDNDIcon"] as? Bool ?? true,
            hasVibrationIcon: dict["hasVibrationIcon"] as? Bool ?? false,
            hasMutedIcon: dict["hasMutedIcon"] as? Bool ?? true,
            hasFlashlightIcon: dict["hasFlashlightIcon"] as? Bool ?? true,
            hasTimerIcon: dict["hasTimerIcon"] as? Bool ?? true
        )

        colors = .init(
            timeColor: UIColor(hex: dict["timeColor"] as? String ?? "FFFFFF"),
            dateColor: UIColor(hex: dict["dateColor"] as? String ?? "FFFFFF"),
            dividerColor: UIColor(hex: dict["dividerColor"] as? String ?? "FFFFFF"),
            weatherColor: UIColor(hex: dict["weatherColor"] as? String ?? "FFFFFF"),
            lockIconColor: UIColor(hex: dict["lockIconColor"] as? String ?? "FFFFFF"),
            alarmIconColor: UIColor(hex: dict["alarmIconColor"] as? String ?? "FFFFFF"),
            dndIconColor: UIColor(hex: dict["dndIconColor"] as? String ?? "FFFFFF"),
            flashlightIconColor: UIColor(hex: dict["flashlightIconColor"] as? String ?? "FFFFFF"),
            vibrationIconColor: UIColor(hex: dict["vibrationIconColor"] as? String ?? "FFFFFF"),
            mutedIconColor: UIColor(hex: dict["mutedIconColor"] as? String ?? "FFFFFF"),
            secondsIconColor: UIColor(hex: dict["secondsIconColor"] as? String ?? "FFFFFF"),
            timerIconColor: UIColor(hex: dict["timerIconColor"] as? String ?? "FFFFFF")
        )
    }
}
