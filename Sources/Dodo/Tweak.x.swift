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
        dodoController.view.heightAnchor.constraint(equalToConstant: PreferenceManager.shared.settings.dodoHeight).isActive = true
    }
    
    func _listViewDefaultContentInsets() -> UIEdgeInsets {
        var insets = orig._listViewDefaultContentInsets()
        insets.bottom = PreferenceManager.shared.settings.dodoHeight
        
        guard PreferenceManager.shared.settings.timeMediaPlayerStyle != .mediaPlayer else {
            return insets
        }
        
        insets.top -= dodoNotificationVerticalOffset()
        return insets
    }
    
    func _minInsetsToPushDateOffScreen() -> Double {
        guard PreferenceManager.shared.settings.timeMediaPlayerStyle != .mediaPlayer else {
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
            return PreferenceManager.shared.settings.notificationVerticalOffset
        }
        return 0
    }
}

//MARK: - Updating time
class SBLockScreenManager_Hook: ClassHook<SBLockScreenManager> {
    typealias Group = Main

    func lockUIFromSource(_ source: Int, withOptions options: AnyObject) {
        orig.lockUIFromSource(source, withOptions: options)
        
        guard PreferenceManager.shared.settings.timeMediaPlayerStyle != .mediaPlayer else {
            return
        }
        
        LockIcon.ViewModel.shared.lockImageName = "lock.fill"
    }
    
    func _runUnlockActionBlock(_ run: Bool) {
        orig._runUnlockActionBlock(run)
        guard run else {
            return
        }
        
        guard PreferenceManager.shared.settings.timeMediaPlayerStyle != .mediaPlayer else {
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
        
        guard PreferenceManager.shared.settings.timeMediaPlayerStyle != .time else {
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
        
        guard PreferenceManager.shared.settings.timeMediaPlayerStyle != .time else {
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
        
        guard PreferenceManager.shared.settings.timeMediaPlayerStyle != .time else {
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
        
        guard PreferenceManager.shared.settings.timeMediaPlayerStyle != .mediaPlayer else {
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
        guard PreferenceManager.shared.settings.timeMediaPlayerStyle != .time else {
            return orig.initWithFrame(frame)
        }
        return nil
    }
}

class SBUIProudLockIconView_Hook: ClassHook<SBUIProudLockIconView> {
    typealias Group = Main

    func didMoveToWindow() {
        orig.didMoveToWindow()
        
        guard PreferenceManager.shared.settings.timeMediaPlayerStyle != .mediaPlayer else {
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
        
        let startY: CGFloat = {
            var value = screenHeight
            value -= (PreferenceManager.shared.settings.dodoHeight + androBarHeight + 30)
            return value / screenHeight
        }()
        
        let endY: CGFloat = {
            var value = screenHeight
            value -= (PreferenceManager.shared.settings.dodoHeight + androBarHeight - 15)
            return value / screenHeight
        }()
        
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
    PreferenceManager.shared.setDictionary(prefsDict() ?? [String : Any]())
}

struct Gradi: Tweak {
    init() {
        readPrefs()
        if (PreferenceManager.shared.settings.isEnabled) {
            Main().activate()
        }
    }
}
