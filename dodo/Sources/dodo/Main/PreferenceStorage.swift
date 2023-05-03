import Foundation
import Comet

// MARK: - Internal

final class PreferenceStorage: ObservableObject {
    private static let registry: String = "/var/mobile/Library/Preferences/com.ginsu.dodo.plist"
    // Preferences
    @Published(key: "isEnabled", registry: registry) var isEnabled = true
    
    // MARK: - Behaviour
    // Date / time formatting
    @Published(key: "timeTemplate", registry: registry) var selectedTimeTemplate = 0
    @Published(key: "timeTemplateCustomFormat", registry: registry) var timeTemplateCustomFormat = "h:mm"
    @Published(key: "isEnabled24HourMode", registry: registry) var isEnabled24HourMode = false
    @Published(key: "dateTemplate", registry: registry) var selectedDateTemplate = 0
    @Published(key: "dateTemplateCustomFormat", registry: registry) var dateTemplateCustomFormat = "EEEE, MMMM d"

    // Dimensions
    @Published(key: "notificationVerticalOffset", registry: registry) var notificationVerticalOffset = 190.0
    
    // Charging indication
    @Published(key: "hasChargingFlash", registry: registry) var hasChargingFlash = false
    
    // MARK: - Appearance
    // Time / media styling
    @Published(key: "timeMediaPlayerStyle", registry: registry) var timeMediaPlayerStyle = 2
    @Published(key: "playerStyle", registry: registry) var playerStyle = 0
    @Published(key: "showDivider", registry: registry) var showDivider = true
    @Published(key: "showSuggestions", registry: registry) var showSuggestions = true
    @Published(key: "isMarqueeLabels", registry: registry) var isMarqueeLabels = true
    
    // Colors
    @Published(key: "timeColor", registry: registry) var timeColor = "FFFFFF"
    @Published(key: "dateColor", registry: registry) var dateColor = "FFFFFF"
    @Published(key: "dividerColor", registry: registry) var dividerColor = "FFFFFF"

    // Theming
    @Published(key: "themeName", registry: registry) var themeName = "Rounded"
    
    // Fonts
    @Published(key: "selectedFont", registry: registry) var selectedFont = 0
    @Published(key: "timeFontSize", registry: registry) var timeFontSize = 50.0
    @Published(key: "dateFontSize", registry: registry) var dateFontSize = 15.0
    @Published(key: "weatherFontSize", registry: registry) var weatherFontSize = 15.0

    // MARK: - Favourite apps
    @Published(key: "hasFavouriteApps", registry: registry) var hasFavouriteApps = true
    @Published(key: "selectedFavouriteApps", registry: registry) var selectedFavouriteApps: [String] = [
        "com.apple.camera",
        "com.apple.Preferences",
        "com.apple.MobileSMS",
        "com.apple.mobilemail"
    ]
    @Published(key: "favouriteAppsGridSizeType", registry: registry) var favouriteAppsGridSizeType = 0
    @Published(key: "favouriteAppsFlexibleGridItemSize", registry: registry) var favouriteAppsFlexibleGridItemSize = 40.0
    @Published(key: "favouriteAppsFixedGridItemSize", registry: registry) var favouriteAppsFixedGridItemSize = 40.0
    @Published(key: "favouriteAppsFlexibleGridColumnAmount", registry: registry) var favouriteAppsFlexibleGridColumnAmount = 3
    @Published(key: "favouriteAppsFixedGridColumnAmount", registry: registry) var favouriteAppsFixedGridColumnAmount = 3
    @Published(key: "isVisibleFavouriteAppsFade", registry: registry) var isVisibleFavouriteAppsFade = false
    
    // MARK: - Weather
    @Published(key: "showWeather", registry: registry) var showWeather = true
    @Published(key: "isActiveWeatherAutomaticRefresh", registry: registry) var isActiveWeatherAutomaticRefresh = true
    @Published(key: "weatherColor", registry: registry) var weatherColor = "FFFFFF"

    
    // MARK: - Status indicators
    @Published(key: "hasStatusItems", registry: registry) var hasStatusItems = true
    @Published(key: "indicatorSize", registry: registry) var indicatorSize = 18.0
    
    // Items
    @Published(key: "hasLockIcon", registry: registry) var hasLockIcon = true
    @Published(key: "lockIconColor", registry: registry) var lockIconColor = "FFFFFF"

    @Published(key: "hasChargingIcon", registry: registry) var hasChargingIcon = true
    
    @Published(key: "hasAlarmIcon", registry: registry) var hasAlarmIcon = true
    @Published(key: "alarmIconColor", registry: registry) var alarmIconColor = "FFFFFF"
    
    @Published(key: "hasDNDIcon", registry: registry) var hasDNDIcon = true
    @Published(key: "dndIconColor", registry: registry) var dndIconColor = "FFFFFF"
    
    @Published(key: "hasFlashlightIcon", registry: registry) var hasFlashlightIcon = true
    @Published(key: "flashlightIconColor", registry: registry) var flashlightIconColor = "FFFFFF"

    @Published(key: "hasVibrationIcon", registry: registry) var hasVibrationIcon = false
    @Published(key: "vibrationIconColor", registry: registry) var vibrationIconColor = "FFFFFF"
    
    @Published(key: "hasMutedIcon", registry: registry) var hasMutedIcon = true
    @Published(key: "mutedIconColor", registry: registry) var mutedIconColor = "FFFFFF"
    
    @Published(key: "hasSecondsIcon", registry: registry) var hasSecondsIcon = true
    @Published(key: "secondsIconColor", registry: registry) var secondsIconColor = "FFFFFF"
}
