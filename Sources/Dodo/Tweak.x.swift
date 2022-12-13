import Orion
import DodoC
import SwiftUI

struct Main: HookGroup {}

//MARK: - Dodo view
class CSCombinedListViewController_Hook: ClassHook<CSCombinedListViewController> {
    typealias Group = Main
    
    @Property (.nonatomic, .retain) var dodoController = DDBaseController()
    
    func viewDidLoad() {
        orig.viewDidLoad()
        //Init Dodo base controller
        dodoController = DDBaseController()
        dodoController.view.translatesAutoresizingMaskIntoConstraints = false
        target.addChild(dodoController)
        target.view.addSubview(dodoController.view)
    }
    
    func viewWillAppear(_ animated: Bool) {
        orig.viewWillAppear(animated)
        setupDodoConstrains()
    }
    
    //orion: new
    func setupDodoConstrains() {
        dodoController.view.bottomAnchor.constraint(equalTo: target.view.bottomAnchor).isActive = true
        dodoController.view.leftAnchor.constraint(equalTo: target.view.leftAnchor).isActive = true
        dodoController.view.widthAnchor.constraint(equalTo: target.view.widthAnchor).isActive = true
        dodoController.view.heightAnchor.constraint(equalToConstant: Settings.dodoHeight).isActive = true
    }
    
    func _listViewDefaultContentInsets() -> UIEdgeInsets {
        var insets = orig._listViewDefaultContentInsets()
        insets.bottom = Settings.dodoHeight
        
        guard Settings.timeMediaPlayerStyle != .mediaPlayer else {
            return insets
        }
        
        insets.top -= dodoNotificationVerticalOffset()
        return insets
    }
    
    func _minInsetsToPushDateOffScreen() -> Double {
        guard Settings.timeMediaPlayerStyle != .mediaPlayer else {
            return orig._minInsetsToPushDateOffScreen()
        }
        
        let offset = orig._minInsetsToPushDateOffScreen()
        let newOffset = offset - dodoNotificationVerticalOffset()
        return newOffset
    }
    
    func _layoutListView() {
        orig._layoutListView()
        target._updateListViewContentInset()
    }
    
    //orion: new
    func dodoNotificationVerticalOffset() -> Double {
        guard UIScreen.main.bounds.width > UIScreen.main.bounds.height else {
            return Settings.notificationVerticalOffset
        }
        return 0
    }
}

//MARK: - Updating time
class SBLockScreenManager_Hook: ClassHook<SBLockScreenManager> {
    typealias Group = Main

    func lockUIFromSource(_ source: Int, withOptions options: AnyObject) {
        orig.lockUIFromSource(source, withOptions: options)
        
        guard Settings.timeMediaPlayerStyle != .mediaPlayer else {
            return
        }
        
        LockIcon.ViewModel.shared.lockImageName = "lock.fill"
    }
    
    func _runUnlockActionBlock(_ run: Bool) {
        orig._runUnlockActionBlock(run)
        guard run else {
            return
        }
        
        guard Settings.timeMediaPlayerStyle != .mediaPlayer else {
            return
        }
        
        LockIcon.ViewModel.shared.lockImageName = "lock.open.fill"
    }

    func lockScreenViewControllerDidDismiss() {
        orig.lockScreenViewControllerDidDismiss()
        //Lock screen dismissed
        DataRefresher.shared.toggleTimer(on: false)
    }

    func lockScreenViewControllerDidPresent() {
        orig.lockScreenViewControllerDidPresent()

        guard DataRefresher.shared.screenOn else {
            return
        }
        //Lock screen presented
        DataRefresher.shared.toggleTimer(on: true)
    }

    func _handleBacklightLevelWillChange(_ arg1: NSNotification) {
        orig._handleBacklightLevelWillChange(arg1)

        guard let userInfo = arg1.userInfo else {
            return
        }

        guard let updatedBacklightLevel = userInfo["SBBacklightNewFactorKey"] as? Int else {
            return
        }

        DataRefresher.shared.screenOn = updatedBacklightLevel != 0
        //Screen turned on/off.
        DataRefresher.shared.toggleTimer(on: DataRefresher.shared.screenOn)
    }
}

//MARK: - Now playing app and currently playing track info.
class SBMediaController_Hook: ClassHook<SBMediaController> {
    typealias Group = Main

    func _mediaRemoteNowPlayingApplicationIsPlayingDidChange(_ arg1: AnyObject) {
        orig._mediaRemoteNowPlayingApplicationIsPlayingDidChange(arg1)
        
        guard Settings.timeMediaPlayerStyle != .time else {
            return
        }
        
        if let nowPlayingApp = target.nowPlayingApplication() {
            AppsManager.suggestedAppBundleIdentifier = nowPlayingApp.bundleIdentifier
            MediaPlayer.ViewModel.shared.hasActiveMediaApp = true
        } else {
            MediaPlayer.ViewModel.shared.hasActiveMediaApp = false
        }
        //Update play/pause button status.
        MediaPlayer.ViewModel.shared.togglePlayPause(shouldPlay: !target.isPaused())
    }
    
    func setNowPlayingInfo(_ info: NSDictionary) {
        orig.setNowPlayingInfo(info)
        
        guard Settings.timeMediaPlayerStyle != .time else {
            return
        }
        
        //Update current track info.
        MediaPlayer.ViewModel.shared.updateInfo()
    }
}

//MARK: - Refresh media info on SpringBoard launch.
class SpringBoard_Hook: ClassHook<SpringBoard> {
    typealias Group = Main

    func applicationDidFinishLaunching(_ application: AnyObject) {
        orig.applicationDidFinishLaunching(application)
        
        guard Settings.timeMediaPlayerStyle != .time else {
            return
        }
        
        /** If media plays through a respring, we need this code to update the media info when SpringBoard
         launches so that the play/pause button shows the correct image. **/
        SBMediaController.sharedInstance().setNowPlayingInfo(0)
    }
}

//MARK: - Misc
class SBFLockScreenDateView_Hook: ClassHook<SBFLockScreenDateView> {
    typealias Group = Main

    func didMoveToWindow() {
        orig.didMoveToWindow()
        
        guard Settings.timeMediaPlayerStyle != .mediaPlayer else {
            return
        }
        
        target.removeFromSuperview()
    }
}

class CSQuickActionsView_Hook: ClassHook<CSQuickActionsView> {
    typealias Group = Main

    func didMoveToWindow() {
        orig.didMoveToWindow()
        target.removeFromSuperview()
    }
}

class CSTeachableMomentsContainerView_Hook: ClassHook<CSTeachableMomentsContainerView> {
    typealias Group = Main

    func didMoveToWindow() {
        orig.didMoveToWindow()
        target.removeFromSuperview()
    }
}

class CSAdjunctItemView_Hook: ClassHook<CSAdjunctItemView> {
    typealias Group = Main

    func initWithFrame(_ frame: CGRect) -> Target? {
        guard Settings.timeMediaPlayerStyle != .time else {
            return orig.initWithFrame(frame)
        }
        return nil
    }
}

class SBUIProudLockIconView_Hook: ClassHook<SBUIProudLockIconView> {
    typealias Group = Main

    func didMoveToWindow() {
        orig.didMoveToWindow()
        
        guard Settings.timeMediaPlayerStyle != .mediaPlayer else {
            return
        }
        
        target.removeFromSuperview()
    }
}

class SBUICallToActionLabel_Hook: ClassHook<SBUICallToActionLabel> {
    func initWithFrame(_ rect: CGRect) -> Target? {
        return nil
    }
}

class CSHomeAffordanceView_Hook: ClassHook<CSHomeAffordanceView> {
    func initWithFrame(_ rect: CGRect) -> Target? {
        return nil
    }
}

class CSPageControl_Hook: ClassHook<CSPageControl> {
    func initWithFrame(_ rect: CGRect) -> Target? {
        return nil
    }
}

class NCNotificationStructuredListViewController_Hook: ClassHook<NCNotificationStructuredListViewController> {
    typealias Group = Main
    
    @Property (.nonatomic, .retain) var cropFrame = CAGradientLayer()

    func viewDidLoad() {
        orig.viewDidLoad()
        cropFrame = CAGradientLayer()
        cropFrame.frame = target.view.bounds
        cropFrame.colors = [UIColor.white.cgColor, UIColor.clear.cgColor]
        target.view.layer.mask = cropFrame
    }
    
    func viewWillAppear(_ animated: Bool) {
        orig.viewWillAppear(animated)
        let screenHeight = UIScreen.main.bounds.height
        
        let androBarHeight = GSUtilities.sharedInstance().isAndroBarInstalled()
        ? GSUtilities.sharedInstance().androBarHeight
        : 0
        
        let startY = (screenHeight - (Settings.dodoHeight + androBarHeight + 30)) / screenHeight
        let endY = (screenHeight - (Settings.dodoHeight + androBarHeight - 15)) / screenHeight
        
        cropFrame.startPoint = CGPoint(
            x: 0.5,
            y: startY
        )
        
        cropFrame.endPoint = CGPoint(
            x: 0.5,
            y: endY
        )
    }
}

//MARK: - Preferences
fileprivate func prefsDict() -> [String : AnyObject]? {
    var propertyListFormat =  PropertyListSerialization.PropertyListFormat.xml

    let path = "/var/mobile/Library/Preferences/com.ginsu.dodo.plist"

    if !FileManager().fileExists(atPath: path) {
        try? FileManager().copyItem(
            atPath: "Library/PreferenceBundles/dodo.bundle/defaults.plist",
            toPath: path
        )
    }

    let plistURL = URL(fileURLWithPath: path)
    
    guard let plistXML = try? Data(contentsOf: plistURL) else {
        return nil
    }
    
    guard let plistDict = try! PropertyListSerialization.propertyList(
        from: plistXML,
        options: .mutableContainersAndLeaves,
        format: &propertyListFormat
    ) as? [String : AnyObject] else {
        return nil
    }

    return plistDict
}

fileprivate func readPrefs() {

    let dict = prefsDict() ?? [String : Any]()

    //Reading values
    Settings.isEnabled = dict[
        "isEnabled",
        default: true
    ] as! Bool
    
    Settings.timeMediaPlayerStyle = TimeMediaPlayerStyle(
        rawValue: dict[
            "timeMediaPlayerStyle",
            default: 2
        ] as! Int
    )!
    
    Settings.playerStyle = MediaPlayerStyle(
        rawValue: dict[
            "playerStyle",
            default: 0
        ] as! Int
    )!
    
    Settings.hasModularBounceEffect = dict[
        "hasModularBounceEffect",
        default: true
    ] as! Bool
    
    Settings.hasChargingIndication = dict[
        "hasChargingIndication",
        default: true
    ] as! Bool
    
    Settings.showDivider = dict[
        "showDivider",
        default: true
    ] as! Bool
    
    Settings.themeName = dict[
        "themeName",
        default: "Rounded"
    ] as! String

    let fontType = dict["fontType"] as? Int ?? 2
    switch fontType {
    case 1:
        Settings.fontType = .default
        break
    case 2:
        Settings.fontType = .rounded
        break
    case 3:
        Settings.fontType = .monospaced
        break
    case 4:
        Settings.fontType = .serif
        break
    default:
        Settings.fontType = .rounded
        break
    }
    
    //TimeDate
    let timeTemplate = dict[
        "timeTemplate",
        default: 0
    ] as! Int
    
    switch timeTemplate {
    case 0:
        Settings.timeTemplate = .time
        break
    case 1:
        Settings.timeTemplate = .timeWithSeconds
        break
    case 2:
        Settings.timeTemplate = .timeCustom(dict["timeTemplateCustom"] as? String ?? "h:mm")
        break
    default:
        Settings.timeTemplate = .time
        break
    }
    
    let dateTemplate = dict[
        "dateTemplate",
        default: 0
    ] as! Int
    
    switch dateTemplate {
    case 0:
        Settings.dateTemplate = .date
        break
    case 1:
        Settings.dateTemplate = .dateCustom(dict["dateTemplateCustom"] as? String ?? "EEEE, MMMM d")
        break
    default:
        Settings.dateTemplate = .date
        break
    }
    
    //Favourite apps
    Settings.hasFavouriteApps = dict[
        "hasFavouriteApps",
        default: true
    ] as! Bool
    
    AppsManager.favouriteAppBundleIdentifiers = dict[
        "favouriteApps",
        default: [
            "com.apple.camera",
            "com.apple.Preferences",
            "com.apple.MobileSMS",
            "com.apple.mobilemail"
        ]
    ] as! [String]
    
    //Dimensions
    Settings.dodoHeight = dict[
        "dodoHeight",
        default: 250.0
    ] as! Double

    //Colors
    Colors.timeColor = UIColor(
        hexString: dict[
            "timeColor",
            default: "#FFFFFFFF"
        ] as! String
    )
    
    Colors.dateColor = UIColor(
        hexString: dict[
            "dateColor",
            default: "#FFFFFFFF"
        ] as! String
    )
    
    Colors.dividerColor = UIColor(
        hexString: dict[
            "dividerColor",
            default: "#FFFFFFFF"
        ] as! String
    )
    
    Colors.weatherColor = UIColor(
        hexString: dict[
            "weatherColor",
            default: "#FFFFFFFF"
        ] as! String
    )
    
    Colors.lockIconColor = UIColor(
        hexString: dict[
            "lockIconColor",
            default: "#FFFFFFFF"
        ] as! String
    )
}

struct Gradi: Tweak {
    init() {
        readPrefs()
        if (Settings.isEnabled) {
            Main().activate()
        }
    }
}
