import Orion
import DodoC

struct Main: HookGroup {}

//MARK: - Dodo view
class CSCombinedListViewController_Hook: ClassHook<CSCombinedListViewController> {
    typealias Group = Main
    
    @Property (.nonatomic, .retain) var dodoController = DDBaseController()
    @Property (.nonatomic, .retain) var widthConstraint = NSLayoutConstraint()
    
    func viewDidLoad() {
        orig.viewDidLoad()
        
        // Init Dodo base controller
        dodoController = DDBaseController()
        dodoController.view.translatesAutoresizingMaskIntoConstraints = false
        target.addChild(dodoController)
        target.view.addSubview(dodoController.view)
        
        // Create a reference to the width anchor because it changes depending on device orientation.
        widthConstraint = dodoController.view.widthAnchor.constraint(equalTo: target.view.widthAnchor)
        
        // Activate these constraints once.
        NSLayoutConstraint.activate([
            dodoController.view.bottomAnchor.constraint(equalTo: target.view.bottomAnchor),
            dodoController.view.leftAnchor.constraint(equalTo: target.view.leftAnchor),
        ])
    }
    
    func viewWillAppear(_ animated: Bool) {
        orig.viewWillAppear(animated)
        let isLandscape = (UIScreen.main.bounds.width > UIScreen.main.bounds.height) && !UIDevice.currentIsIPad()
        Dimensions.shared.isLandscape = isLandscape
        widthConstraint.isActive = !Dimensions.shared.isLandscape
    }
    
    func _listViewDefaultContentInsets() -> UIEdgeInsets {
        var insets = orig._listViewDefaultContentInsets()
        
        guard !Dimensions.shared.isLandscape || UIDevice.currentIsIPad() else {
            return insets
        }
        
        insets.bottom = Dimensions.shared.dodoFrame.height + 50
        
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
        
        guard !Dimensions.shared.isLandscape || UIDevice.currentIsIPad() else {
            return orig._minInsetsToPushDateOffScreen()
        }
        
        let offset = orig._minInsetsToPushDateOffScreen()
        let newOffset = offset - dodoNotificationVerticalOffset()
        return newOffset
    }
    
    //orion: new
    func dodoNotificationVerticalOffset() -> Double {
        guard !Dimensions.shared.isLandscape || UIDevice.currentIsIPad() else {
            return 0
        }
        return PreferenceManager.shared.settings.notificationVerticalOffset
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
        
        /* If media plays through a respring, we need this code to update the media info when SpringBoard
         launches so that the play/pause button shows the correct image. */
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
            name: NSNotification.Name("Dodo.didUpdateHeight"),
            object: nil
        )
        
        cropFrame = CAGradientLayer()
        cropFrame.frame = target.view.bounds
        cropFrame.colors = [UIColor.white.cgColor, UIColor.clear.cgColor]
    }
    
    func viewDidAppear(_ animated: Bool) {
        orig.viewDidAppear(animated)
        guard !Dimensions.shared.isLandscape || UIDevice.currentIsIPad() else {
            target.view.layer.mask = nil
            return
        }
        dodoSetupMask()
    }
    
    //orion: new
    func dodoSetupMask() {
        target.view.layer.mask = cropFrame
                
        let screenHeight = target.view.bounds.maxY
        let startY: CGFloat = (Dimensions.shared.dodoFrame.minY - Dimensions.shared.androBarHeight - 50) / screenHeight
        let endY: CGFloat = (Dimensions.shared.dodoFrame.minY - Dimensions.shared.androBarHeight) / screenHeight
        
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

//MARK: - Preferences
private func prefsDict() -> [String : Any]? {
    var propertyListFormat =  PropertyListSerialization.PropertyListFormat.xml
    let path = "/var/mobile/Library/Preferences/com.ginsu.dodo.plist"
    let defaultsPath = GSUtilities.sharedInstance().correctedFilePathFromPath(
        withRootPrefix: ":root:Library/PreferenceBundles/dodo.bundle/defaults.plist"
    )!

    do {
        if !FileManager().fileExists(atPath: path) {
            try FileManager().copyItem(
                atPath: defaultsPath,
                toPath: path
            )
        }
        let plistURL = URL(fileURLWithPath: path)
        let plistXML = try Data(contentsOf: plistURL)
        let plistDict = try PropertyListSerialization.propertyList(
            from: plistXML,
            options: .mutableContainersAndLeaves,
            format: &propertyListFormat
        ) as? [String : AnyObject]
        return plistDict
    } catch {
        return nil
    }
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
        }
    }
}
