//
//  PreferenceManager.swift
//  
//
//  Created by Noah Little on 14/12/2022.
//

import Foundation
import SwiftUI

final class PreferenceManager {
    private(set) var settings: Settings!
    static let shared = PreferenceManager()
    let dataRefresher = DataRefresher()
    let defaults = UserDefaults.standard
    
    func loadSettings(withDictionary dict: [String: Any]) {
        self.settings = Settings(withDictionary: dict)
    }
}

struct Settings {
    // Global on/off
    var isEnabled: Bool
    // Media player
    var timeMediaPlayerStyle: TimeMediaPlayerStyle
    var playerStyle: MediaPlayerStyle
    var showSuggestions: Bool
    var showDivider: Bool
    // Charging
    var hasChargingFlash: Bool
    // Aesthetics
    var fontType: Font.Design
    var timeFontSize: Double
    var dateFontSize: Double
    var weatherFontSize: Double
    var themeName: String
    // Positioning & Dimensions
    var notificationVerticalOffset: Double
    // TimeDate
    var timeTemplate: DateTemplate
    var dateTemplate: DateTemplate
    var is24HourModeEnabled: Bool
    // Favourite apps
    var hasFavouriteApps: Bool
    var isVisibleFavouriteAppsFade: Bool
    // Weather
    var showWeather: Bool
    var isActiveWeatherAutomaticRefresh: Bool
    // Status items
    var hasStatusItems: Bool
    var hasLockIcon: Bool
    var hasChargingIcon: Bool
    var hasDNDIcon: Bool
    var hasAlarmIcon: Bool
    var hasFlashlightIcon: Bool
    var hasVibrationIcon: Bool
    var hasMutedIcon: Bool
    
    init(withDictionary dict: [String: Any]) {
        isEnabled = dict["isEnabled", default: true] as! Bool
        timeMediaPlayerStyle = TimeMediaPlayerStyle(rawValue: dict["timeMediaPlayerStyle", default: 2] as! Int)!
        playerStyle = MediaPlayerStyle(rawValue: dict["playerStyle", default: 0] as! Int)!
        showWeather = dict["showWeather", default: true] as! Bool
        showSuggestions = dict["showSuggestions", default: true] as! Bool
        showDivider = dict["showDivider", default: true] as! Bool
        hasChargingFlash = dict["hasChargingFlash", default: false] as! Bool
        themeName = dict["themeName", default: "Rounded"] as! String
        is24HourModeEnabled = dict["is24HourModeEnabled", default: false] as! Bool
        hasFavouriteApps = dict["hasFavouriteApps", default: true] as! Bool
        isVisibleFavouriteAppsFade = dict["isVisibleFavouriteAppsFade", default: false] as! Bool
        notificationVerticalOffset = dict["notificationVerticalOffset", default: 190.0] as! Double
        timeFontSize = dict["timeFontSize", default: 50.0] as! Double
        dateFontSize = dict["dateFontSize", default: 15.0] as! Double
        weatherFontSize = dict["weatherFontSize", default: 15.0] as! Double
        hasStatusItems = dict["hasStatusItems", default: true] as! Bool
        hasLockIcon = dict["hasLockIcon", default: true] as! Bool
        hasChargingIcon = dict["hasChargingIcon", default: true] as! Bool
        isActiveWeatherAutomaticRefresh = dict["isActiveWeatherAutomaticRefresh", default: true] as! Bool
        hasDNDIcon = dict["hasDNDIcon", default: true] as! Bool
        hasAlarmIcon = dict["hasAlarmIcon", default: true] as! Bool
        hasFlashlightIcon = dict["hasFlashlightIcon", default: true] as! Bool
        hasVibrationIcon = dict["hasVibrationIcon", default: false] as! Bool
        hasMutedIcon = dict["hasMutedIcon", default: true] as! Bool
        
        let fontType = dict["fontType", default: 2] as! Int
        switch fontType {
        case 1:
            self.fontType = .default
            break
        case 2:
            self.fontType = .rounded
            break
        case 3:
            self.fontType = .monospaced
            break
        case 4:
            self.fontType = .serif
            break
        default:
            self.fontType = .rounded
            break
        }
        
        let timeTemplate = dict["timeTemplate", default: 0] as! Int
        switch timeTemplate {
        case 0:
            self.timeTemplate = .time
            break
        case 1:
            self.timeTemplate = .timeWithSeconds
            break
        case 2:
            self.timeTemplate = .timeCustom(dict["timeTemplateCustom", default: "h:mm"] as! String)
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
            self.dateTemplate = .dateCustom(dict["dateTemplateCustom", default: "EEEE, MMMM d"] as! String)
            break
        default:
            self.dateTemplate = .date
            break
        }
        
        AppsManager.favouriteAppBundleIdentifiers = dict[
            "favouriteApps",
            default: [
                "com.apple.camera",
                "com.apple.Preferences",
                "com.apple.MobileSMS",
                "com.apple.mobilemail"
            ]
        ] as? [String]
        
        Colors.timeColor = UIColor(hexString: dict["timeColor", default: "#FFFFFFFF"] as! String)
        Colors.dateColor = UIColor(hexString: dict["dateColor", default: "#FFFFFFFF"] as! String)
        Colors.dividerColor = UIColor(hexString: dict["dividerColor", default: "#FFFFFFFF"] as! String)
        Colors.weatherColor = UIColor(hexString: dict["weatherColor", default: "#FFFFFFFF"] as! String)
        Colors.lockIconColor = UIColor(hexString: dict["lockIconColor", default: "#FFFFFFFF"] as! String)
        Colors.alarmIconColor = UIColor(hexString: dict["alarmIconColor", default: "#FFFFFFFF"] as! String)
        Colors.dndIconColor = UIColor(hexString: dict["dndIconColor", default: "#FFFFFFFF"] as! String)
        Colors.flashlightIconColor = UIColor(hexString: dict["flashlightIconColor", default: "#FFFFFFFF"] as! String)
        Colors.vibrationIconColor = UIColor(hexString: dict["vibrationIconColor", default: "#FFFFFFFF"] as! String)
        Colors.mutedIconColor = UIColor(hexString: dict["mutedIconColor", default: "#FFFFFFFF"] as! String)
        
        Dimensions.shared.favouriteAppsGridSizeType = GridSizeType(rawValue: dict["favouriteAppsGridSizeType", default: 0] as! Int)!
        Dimensions.shared.favouriteAppsFlexibleGridItemSize = dict["favouriteAppsFlexibleGridItemSize", default: 40.0] as! Double
        Dimensions.shared.favouriteAppsFlexibleGridColumnAmount = dict["favouriteAppsFlexibleGridColumnAmount", default: 3] as! Int
        Dimensions.shared.favouriteAppsFixedGridItemSize = dict["favouriteAppsFixedGridItemSize", default: 40.0] as! Double
        Dimensions.shared.favouriteAppsFixedGridColumnAmount = dict["favouriteAppsFixedGridColumnAmount", default: 3] as! Int
        
        let indicatorSize = dict["indicatorSize", default: 18] as! Int
        Dimensions.shared.statusItemSize = CGSize(width: indicatorSize, height: indicatorSize)
    }
}
