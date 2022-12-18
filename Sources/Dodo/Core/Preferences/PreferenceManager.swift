//
//  PreferenceManager.swift
//  
//
//  Created by Noah Little on 14/12/2022.
//

import Foundation
import SwiftUI

final class PreferenceManager {
    public static let shared: PreferenceManager = PreferenceManager()
    private var dictionary: Dictionary<String, Any>?
    private(set) var settings: Settings
    
    init(dictionary: Dictionary<String, Any>? = nil) {
        settings = .init()
        if let dictionary {
            setDictionary(dictionary)
        }
    }
    
    func setDictionary(_ dict: Dictionary<String, Any>) {
        self.dictionary = dict
        readDictionary()
    }
    
    private func readDictionary() {
        guard let dictionary else { return }
            
        settings.isEnabled = dictionary[
            "isEnabled",
            default: true
        ] as! Bool
        
        settings.timeMediaPlayerStyle = TimeMediaPlayerStyle(
            rawValue: dictionary[
                "timeMediaPlayerStyle",
                default: 2
            ] as! Int
        )!
        
        settings.playerStyle = MediaPlayerStyle(
            rawValue: dictionary[
                "playerStyle",
                default: 0
            ] as! Int
        )!
        
        settings.hasModularBounceEffect = dictionary[
            "hasModularBounceEffect",
            default: true
        ] as! Bool
        
        settings.hasChargingIndication = dictionary[
            "hasChargingIndication",
            default: true
        ] as! Bool
        
        settings.hasChargingIcon = dictionary[
            "hasChargingIcon",
            default: true
        ] as! Bool
        
        settings.hasChargingFlash = dictionary[
            "hasChargingFlash",
            default: false
        ] as! Bool
        
        settings.showDivider = dictionary[
            "showDivider",
            default: true
        ] as! Bool
        
        settings.showWeather = dictionary[
            "showWeather",
            default: true
        ] as! Bool
        
        settings.themeName = dictionary[
            "themeName",
            default: "Rounded"
        ] as! String

        let fontType = dictionary["fontType"] as? Int ?? 2
        switch fontType {
        case 1:
            settings.fontType = .default
            break
        case 2:
            settings.fontType = .rounded
            break
        case 3:
            settings.fontType = .monospaced
            break
        case 4:
            settings.fontType = .serif
            break
        default:
            settings.fontType = .rounded
            break
        }
        
        // TimeDate
        let timeTemplate = dictionary[
            "timeTemplate",
            default: 0
        ] as! Int
        
        switch timeTemplate {
        case 0:
            settings.timeTemplate = .time
            break
        case 1:
            settings.timeTemplate = .timeWithSeconds
            break
        case 2:
            settings.timeTemplate = .timeCustom(dictionary["timeTemplateCustom"] as? String ?? "h:mm")
            break
        default:
            settings.timeTemplate = .time
            break
        }
        
        let dateTemplate = dictionary[
            "dateTemplate",
            default: 0
        ] as! Int
        
        switch dateTemplate {
        case 0:
            settings.dateTemplate = .date
            break
        case 1:
            settings.dateTemplate = .dateCustom(dictionary["dateTemplateCustom"] as? String ?? "EEEE, MMMM d")
            break
        default:
            settings.dateTemplate = .date
            break
        }
        
        // Favourite apps
        settings.hasFavouriteApps = dictionary[
            "hasFavouriteApps",
            default: true
        ] as! Bool
        
        AppsManager.favouriteAppBundleIdentifiers = dictionary[
            "favouriteApps",
            default: [
                "com.apple.camera",
                "com.apple.Preferences",
                "com.apple.MobileSMS",
                "com.apple.mobilemail"
            ]
        ] as! [String]
        
        // Dimensions
        settings.dodoHeight = dictionary[
            "dodoHeight",
            default: 250.0
        ] as! Double
        
        settings.notificationVerticalOffset = dictionary[
            "notificationVerticalOffset",
            default: 190.0
        ] as! Double

        // Colors
        Colors.timeColor = UIColor(
            hexString: dictionary[
                "timeColor",
                default: "#FFFFFFFF"
            ] as! String
        )
        
        Colors.dateColor = UIColor(
            hexString: dictionary[
                "dateColor",
                default: "#FFFFFFFF"
            ] as! String
        )
        
        Colors.dividerColor = UIColor(
            hexString: dictionary[
                "dividerColor",
                default: "#FFFFFFFF"
            ] as! String
        )
        
        Colors.weatherColor = UIColor(
            hexString: dictionary[
                "weatherColor",
                default: "#FFFFFFFF"
            ] as! String
        )
        
        Colors.lockIconColor = UIColor(
            hexString: dictionary[
                "lockIconColor",
                default: "#FFFFFFFF"
            ] as! String
        )
        
        settings.timeFontSize = dictionary[
            "timeFontSize",
            default: 50.0
        ] as! Double
        
        settings.dateFontSize = dictionary[
            "dateFontSize",
            default: 15.0
        ] as! Double
        
        settings.weatherFontSize = dictionary[
            "weatherFontSize",
            default: 15.0
        ] as! Double
    }
}

extension PreferenceManager {
    struct Settings {
        // Global on/off
        var isEnabled = true
        // Media player
        var timeMediaPlayerStyle: TimeMediaPlayerStyle = .both
        var playerStyle: MediaPlayerStyle = .modular
        var showDivider = true
        var hasModularBounceEffect = true
        // Charging
        var hasChargingIndication = true
        var hasChargingIcon = true
        var hasChargingFlash = false
        // Aesthetics
        var fontType: Font.Design = .rounded
        var timeFontSize: Double = 50
        var dateFontSize: Double = 15
        var weatherFontSize: Double = 15
        var themeName = "Rounded"
        // Positioning & Dimensions
        var notificationVerticalOffset: Double = 190
        var dodoHeight: Double = 250
        // TimeDate
        var timeTemplate: DateTemplate = .time
        var dateTemplate: DateTemplate = .date
        // Favourite apps
        var hasFavouriteApps = true
        // Weather
        var showWeather = true
    }
}
