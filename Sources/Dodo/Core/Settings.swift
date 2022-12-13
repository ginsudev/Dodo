//
//  Settings.swift
//  
//
//  Created by Noah Little on 20/11/2022.
//

import Foundation
import SwiftUI

enum MediaPlayerStyle: Int {
case modular = 0, classic = 1
}

struct Settings {
    // Global on/off
    static var isEnabled = true
    // Media player
    static var timeMediaPlayerStyle: TimeMediaPlayerStyle = .both
    static var playerStyle: MediaPlayerStyle = .modular
    static var showDivider = true
    static var hasModularBounceEffect = true
    static var hasChargingIndication = true
    // Aesthetics
    static var fontType: Font.Design = .rounded
    static var themeName = "Rounded"
    // Positioning & Dimensions
    static var notificationVerticalOffset: Double = 190
    static var dodoHeight: Double = 250
    // TimeDate
    static var timeTemplate: DateTemplate = .time
    static var dateTemplate: DateTemplate = .date
    // Favourite apps
    static var hasFavouriteApps = true
    // Weather
    static var showsWeather = true
}
