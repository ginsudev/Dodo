import Orion
import DodoC
import GSCore

struct Main: HookGroup {}
struct MediaiOS15: HookGroup {}
struct MediaiOS14: HookGroup {}

//MARK: - Dodo view
class CSCombinedListViewController_Hook: ClassHook<CSCombinedListViewController> {
    typealias Group = Main
    
    @Property (.nonatomic, .retain) var dodoController: DDBaseController = .init()
    @Property (.nonatomic, .retain) var trailingConstraint = NSLayoutConstraint()
    
    func viewDidLoad() {
        orig.viewDidLoad()
        
        // Init Dodo base controller
        dodoController.view.translatesAutoresizingMaskIntoConstraints = false
        target.addChild(dodoController)
        target.view.addSubview(dodoController.view)
        
        // Create a reference to the trailing anchor because it changes depending on device orientation.
        trailingConstraint = dodoController.view.trailingAnchor.constraint(equalTo: target.view.trailingAnchor)
        
        // Activate these constraints once.
        NSLayoutConstraint.activate([
            dodoController.view.bottomAnchor.constraint(equalTo: target.view.bottomAnchor),
            dodoController.view.leadingAnchor.constraint(equalTo: target.view.leadingAnchor)
        ])
    }
    
    func viewWillAppear(_ animated: Bool) {
        orig.viewWillAppear(animated)
        
        let isLandscape = (UIScreen.main.bounds.width > UIScreen.main.bounds.height) && !UIDevice.currentIsIPad()
        GlobalState.shared.isLandscape = isLandscape

        trailingConstraint.isActive = !GlobalState.shared.isLandscape
        target.view.setNeedsLayout()
    }
    
    func _listViewDefaultContentInsets() -> UIEdgeInsets {
        var insets = orig._listViewDefaultContentInsets()
        
        guard !GlobalState.shared.isLandscape || UIDevice.currentIsIPad() else {
            return insets
        }
        
        insets.bottom = GlobalState.shared.dodoFrame.height + 50
        
        guard PreferenceManager.shared.settings.mediaPlayer.timeMediaPlayerStyle != .mediaPlayer else {
            return insets
        }
        
        insets.top -= dodoNotificationVerticalOffset()
        return insets
    }
    
    //orion: new
    func dodoNotificationVerticalOffset() -> Double {
        guard !GlobalState.shared.isLandscape || UIDevice.currentIsIPad() else {
            return 0
        }
        return PreferenceManager.shared.settings.dimensions.notificationVerticalOffset
    }
}

//MARK: - Refresh media info on SpringBoard launch.

class SpringBoard_Hook: ClassHook<SpringBoard> {
    typealias Group = Main

    func applicationDidFinishLaunching(_ application: AnyObject) {
        orig.applicationDidFinishLaunching(application)
        
        guard PreferenceManager.shared.settings.mediaPlayer.timeMediaPlayerStyle != .time else {
            return
        }
        
        /* If media plays through a respring, we need this code to update the media info when SpringBoard
         launches so that the play/pause button shows the correct image. */
        SBMediaController.sharedInstance().setNowPlayingInfo(0)
    }
}

// MARK: - Media

class CSAdjunctListModel_Hook: ClassHook<CSAdjunctListModel> {
    typealias Group = MediaiOS15
    
    func addOrUpdateItem(_ item: AnyObject) {
        // Never show the default ls media player
        guard PreferenceManager.shared.settings.mediaPlayer.timeMediaPlayerStyle != .time,
              let _ = item as? CSAdjunctListItem,
              item.identifier == "SBDashBoardNowPlayingAssertionIdentifier" else {
            orig.addOrUpdateItem(item)
            return
        }
    }
}

class CSAdjunctItemView_Hook: ClassHook<CSAdjunctItemView> {
    typealias Group = MediaiOS14

    func initWithFrame(_ frame: CGRect) -> Target? {
        guard PreferenceManager.shared.settings.mediaPlayer.timeMediaPlayerStyle != .time else {
            return orig.initWithFrame(frame)
        }
        return nil
    }
}

// MARK: - Content refresh

class SBUIPreciseClockTimer_Hook: ClassHook<SBUIPreciseClockTimer> {
    func _handleTimePassed() {
        orig._handleTimePassed()
        guard PreferenceManager.shared.settings.mediaPlayer.timeMediaPlayerStyle != .mediaPlayer else { return }
        NotificationCenter.default.post(name: .refreshContent, object: nil)
    }
}

class SBLockScreenPluginManager_Hook: ClassHook<NSObject> {
    static var targetName: String = "SBLockScreenPluginManager"
    
    func setEnabled(_ enabled: Bool) {
        orig.setEnabled(enabled)
        GlobalState.shared.isScreenOff = !enabled
    }
}

// MARK: - Misc

class SBFLockScreenDateView_Hook: ClassHook<SBFLockScreenDateView> {
    typealias Group = Main

    func didMoveToWindow() {
        orig.didMoveToWindow()
        guard PreferenceManager.shared.settings.mediaPlayer.timeMediaPlayerStyle != .mediaPlayer else {
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

class SBUIProudLockIconView_Hook: ClassHook<SBUIProudLockIconView> {
    typealias Group = Main

    func didMoveToWindow() {
        orig.didMoveToWindow()
        
        guard PreferenceManager.shared.settings.mediaPlayer.timeMediaPlayerStyle != .mediaPlayer else {
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

class CSCoverSheetViewController_Hook: ClassHook<CSCoverSheetViewController> {
    func _transitionChargingViewToVisible(_ arg1: Bool, showBattery arg2: Bool, animated arg3: Bool) {
        orig._transitionChargingViewToVisible(
            false,
            showBattery: false,
            animated: false
        )
    }
}

class NCNotificationStructuredListViewController_Hook: ClassHook<NCNotificationStructuredListViewController> {
    typealias Group = Main
    
    @Property (.nonatomic, .retain) var cropFrame = CAGradientLayer()

    func viewDidLoad() {
        orig.viewDidLoad()
        
        NotificationCenter.default.addObserver(
            target,
            selector: #selector(dodoSetupMask),
            name: .didUpdateHeight,
            object: nil
        )
        
        cropFrame = CAGradientLayer()
        cropFrame.frame = target.view.bounds
        cropFrame.colors = [UIColor.white.cgColor, UIColor.clear.cgColor]
    }
    
    func viewDidAppear(_ animated: Bool) {
        orig.viewDidAppear(animated)
        guard !GlobalState.shared.isLandscape || UIDevice.currentIsIPad() else {
            target.view.layer.mask = nil
            return
        }
        dodoSetupMask()
    }
    
    //orion: new
    func dodoSetupMask() {
        target.view.layer.mask = cropFrame
                
        let screenHeight = target.view.bounds.maxY
        let androBarHeight = PreferenceManager.shared.settings.dimensions.androBarHeight
        let startY: CGFloat = (GlobalState.shared.dodoFrame.minY - androBarHeight - 50) / screenHeight
        let endY: CGFloat = (GlobalState.shared.dodoFrame.minY - androBarHeight) / screenHeight

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

class DNDNotificationsService_Hook: ClassHook<DNDNotificationsService> {
    func stateService(_ arg1: AnyObject, didReceiveDoNotDisturbStateUpdate update: DNDStateUpdate) {
        orig.stateService(arg1, didReceiveDoNotDisturbStateUpdate: update)
        DispatchQueue.main.async {
            DNDViewModel.shared.isEnabled = update.state.isActive
        }
    }
}

class SBRingerControl_Hook: ClassHook<NSObject> {
    static var targetName: String = "SBRingerControl"
    
    func setRingerMuted(_ isMuted: Bool) {
        orig.setRingerMuted(isMuted)
        NotificationCenter.default.post(
            name: .didChangeRinger,
            object: nil,
            userInfo: [
                "isMuted" : isMuted
            ]
        )
    }
}

// MARK: - Preferences
private func prefsDict() -> [String : Any]? {
    let path = "/var/mobile/Library/Preferences/com.ginsu.dodo.plist"
    let plistURL = URL(fileURLWithPath: path)
    return plistURL.plistDict()
}

private func readPrefs() -> Bool {
    if let dict = prefsDict() {
        PreferenceManager.shared.loadSettings(withDictionary: dict)
        return true
    } else {
        return false
    }
}

struct Dodo: Tweak {
    init() {
        if readPrefs(),
           PreferenceManager.shared.settings.isEnabled {
            Main().activate()
            
            if #available(iOS 15, *) {
                MediaiOS15().activate()
            } else {
                MediaiOS14().activate()
            }
        }
    }
}
