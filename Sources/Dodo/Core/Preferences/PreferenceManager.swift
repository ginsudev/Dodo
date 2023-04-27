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

    private(set) var settings: Settings!
    let defaults = UserDefaults.standard

    let dataRefresher = DataRefresher()
    
    func loadSettings(withDictionary dict: [String: Any]) {
        self.settings = Settings(withDictionary: dict)
    }
}

struct Settings {
    // Global on/off
    let isEnabled: Bool
    // Media player
    let timeMediaPlayerStyle: TimeMediaPlayerStyle
    let playerStyle: MediaPlayerStyle
    let showSuggestions: Bool
    let showDivider: Bool
    let isMarqueeLabels: Bool
    // Charging
    let hasChargingFlash: Bool
    // Aesthetics
    let selectedFont: FontType
    let timeFontSize: Double
    let dateFontSize: Double
    let weatherFontSize: Double
    let themeName: String
    // Positioning & Dimensions
    let notificationVerticalOffset: Double
    // TimeDate
    let timeTemplate: DateTemplate
    let dateTemplate: DateTemplate
    let isEnabled24HourMode: Bool
    // Favourite apps
    let hasFavouriteApps: Bool
    let isVisibleFavouriteAppsFade: Bool
    // Weather
    let showWeather: Bool
    let isActiveWeatherAutomaticRefresh: Bool
    // Status items
    let hasStatusItems: Bool
    let statusItems: [StatusItemView<AnyView>.StatusItem]
    
    init(withDictionary dict: [String: Any]) {
        isEnabled = dict["isEnabled", default: true] as! Bool
        timeMediaPlayerStyle = TimeMediaPlayerStyle(rawValue: dict["timeMediaPlayerStyle", default: 2] as! Int)!
        playerStyle = MediaPlayerStyle(rawValue: dict["playerStyle", default: 0] as! Int)!
        showWeather = dict["showWeather", default: true] as! Bool && Ecosystem.jailbreakType == .root
        showSuggestions = dict["showSuggestions", default: true] as! Bool
        showDivider = dict["showDivider", default: true] as! Bool
        hasChargingFlash = dict["hasChargingFlash", default: false] as! Bool
        themeName = dict["themeName", default: "Rounded"] as! String
        isEnabled24HourMode = dict["isEnabled24HourMode", default: false] as! Bool
        hasFavouriteApps = dict["hasFavouriteApps", default: true] as! Bool
        isVisibleFavouriteAppsFade = dict["isVisibleFavouriteAppsFade", default: false] as! Bool
        notificationVerticalOffset = dict["notificationVerticalOffset", default: 190.0] as! Double
        timeFontSize = dict["timeFontSize", default: 50.0] as! Double
        dateFontSize = dict["dateFontSize", default: 15.0] as! Double
        weatherFontSize = dict["weatherFontSize", default: 15.0] as! Double
        isActiveWeatherAutomaticRefresh = dict["isActiveWeatherAutomaticRefresh", default: true] as! Bool
        hasStatusItems = dict["hasStatusItems", default: true] as! Bool
        isMarqueeLabels = dict["isMarqueeLabels", default: false] as! Bool
        selectedFont = FontType(rawValue: dict["selectedFont", default: 0] as! Int)!
        
        statusItems = {
            var items: [StatusItemView<AnyView>.StatusItem] = []
            if dict["hasLockIcon", default: true] as! Bool { items.append(.lockIcon) }
            if dict["hasSecondsIcon", default: true] as! Bool { items.append(.seconds) }
            if dict["hasChargingIcon", default: true] as! Bool { items.append(.chargingIcon) }
            if dict["hasAlarmIcon", default: true] as! Bool { items.append(.alarms) }
            if dict["hasDNDIcon", default: true] as! Bool { items.append(.dnd) }
            if dict["hasVibrationIcon", default: false] as! Bool { items.append(.vibration) }
            if dict["hasMutedIcon", default: true] as! Bool { items.append(.muted) }
            if dict["hasFlashlightIcon", default: true] as! Bool { items.append(.flashlight) }
            return items
        }()

        let timeTemplate = dict["timeTemplate", default: 0] as! Int
        switch timeTemplate {
        case 0:
            self.timeTemplate = .time
            break
        case 1:
            self.timeTemplate = .timeWithSeconds
            break
        case 2:
            self.timeTemplate = .timeCustom(dict["timeTemplateCustomFormat", default: "h:mm"] as! String)
            break
        default:
            self.timeTemplate = .time
            break
        }
        
        let dateTemplate = dict["dateTemplate", default: 0] as! Int
        switch dateTemplate {
        case 0:
            self.dateTemplate = .date
            break
        case 1:
            self.dateTemplate = .dateCustom(dict["dateTemplateCustomFormat", default: "EEEE, MMMM d"] as! String)
            break
        default:
            self.dateTemplate = .date
            break
        }
        
        AppsManager.shared.favouriteAppBundleIdentifiers = dict[
            "selectedFavouriteApps",
            default: [
                "com.apple.camera",
                "com.apple.Preferences",
                "com.apple.MobileSMS",
                "com.apple.mobilemail"
            ]
        ] as! [String]
        
        Colors.timeColor = UIColor(hex: dict["timeColor", default: "FFFFFF"] as! String)
        Colors.dateColor = UIColor(hex: dict["dateColor", default: "FFFFFF"] as! String)
        Colors.dividerColor = UIColor(hex: dict["dividerColor", default: "FFFFFF"] as! String)
        Colors.weatherColor = UIColor(hex: dict["weatherColor", default: "FFFFFF"] as! String)
        Colors.lockIconColor = UIColor(hex: dict["lockIconColor", default: "FFFFFF"] as! String)
        Colors.alarmIconColor = UIColor(hex: dict["alarmIconColor", default: "FFFFFF"] as! String)
        Colors.dndIconColor = UIColor(hex: dict["dndIconColor", default: "FFFFFF"] as! String)
        Colors.flashlightIconColor = UIColor(hex: dict["flashlightIconColor", default: "FFFFFF"] as! String)
        Colors.vibrationIconColor = UIColor(hex: dict["vibrationIconColor", default: "FFFFFF"] as! String)
        Colors.mutedIconColor = UIColor(hex: dict["mutedIconColor", default: "FFFFFF"] as! String)
        Colors.secondsIconColor = UIColor(hex: dict["secondsIconColor", default: "FFFFFF"] as! String)

        Dimensions.shared.favouriteAppsGridSizeType = GridSizeType(rawValue: dict["favouriteAppsGridSizeType", default: 0] as! Int)!
        Dimensions.shared.favouriteAppsFlexibleGridItemSize = dict["favouriteAppsFlexibleGridItemSize", default: 40.0] as! Double
        Dimensions.shared.favouriteAppsFlexibleGridColumnAmount = dict["favouriteAppsFlexibleGridColumnAmount", default: 3] as! Int
        Dimensions.shared.favouriteAppsFixedGridItemSize = dict["favouriteAppsFixedGridItemSize", default: 40.0] as! Double
        Dimensions.shared.favouriteAppsFixedGridColumnAmount = dict["favouriteAppsFixedGridColumnAmount", default: 3] as! Int
        
        let indicatorSize = dict["indicatorSize", default: 18.0] as! Double
        Dimensions.shared.statusItemSize = CGSize(
            width: indicatorSize,
            height: indicatorSize
        )
    }
}
