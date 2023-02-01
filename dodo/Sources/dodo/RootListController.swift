import Preferences
import dodoC

class RootListController: PSListController {
    private var name = "dodo"
    
    override var specifiers: NSMutableArray? {
        get {
            if let specifiers = value(forKey: "_specifiers") as? NSMutableArray {
                return specifiers
            } else {
                let specifiers = loadSpecifiers(fromPlistName: "Root", target: self)
                setValue(specifiers, forKey: "_specifiers")
                return specifiers
            }
        }
        set {
            super.specifiers = newValue
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.table.keyboardDismissMode = .onDrag

        if let iconPath = GSUtilities.sharedInstance().correctedFilePathFromPath(
            withRootPrefix: ":root:Library/PreferenceBundles/\(name).bundle/PrefIcon.png"
        ), let icon = UIImage(named: iconPath) {
            self.navigationItem.titleView = UIImageView(image: icon)
        }
        
        let applyButton = GSRespringButton()
        self.navigationItem.rightBarButtonItem = applyButton
    }
    
    override func readPreferenceValue(_ specifier: PSSpecifier!) -> Any! {
        var propertyListFormat =  PropertyListSerialization.PropertyListFormat.xml
        
        let plistURL = URL(fileURLWithPath: "/var/mobile/Library/Preferences/com.ginsu.\(name).plist")

        guard let plistXML = try? Data(contentsOf: plistURL) else {
            return specifier.properties["default"]
        }
        
        guard let plistDict = try! PropertyListSerialization.propertyList(from: plistXML, options: .mutableContainersAndLeaves, format: &propertyListFormat) as? [String : AnyObject] else {
            return specifier.properties["default"]
        }
        
        guard let value = plistDict[specifier.properties["key"] as! String] else {
            return specifier.properties["default"]
        }
        
        return value
    }
    
    override func setPreferenceValue(_ value: Any!, specifier: PSSpecifier!) {
        var propertyListFormat =  PropertyListSerialization.PropertyListFormat.xml
        
        let plistURL = URL(fileURLWithPath: "/var/mobile/Library/Preferences/com.ginsu.\(name).plist")

        guard let plistXML = try? Data(contentsOf: plistURL) else {
            return
        }
        
        guard var plistDict = try! PropertyListSerialization.propertyList(from: plistXML, options: .mutableContainersAndLeaves, format: &propertyListFormat) as? [String : AnyObject] else {
            return
        }
    
        plistDict[specifier.properties["key"] as! String] = value! as AnyObject
        
        do {
            let newData = try PropertyListSerialization.data(fromPropertyList: plistDict, format: propertyListFormat, options: 0)
            try newData.write(to: plistURL)
        } catch {
            return
        }
    }
    
    override func tableViewStyle() -> UITableView.Style {
        if #available(iOS 13.0, *) {
            return .insetGrouped
        } else {
            return .grouped
        }
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if (section == 0) {
            return GSHeaderView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 200),
                                twitterHandle: "ginsudev",
                                developerName: "Ginsu",
                                tweakName: "Dodo",
                                tweakVersion: "v3.4.5",
                                email: "njl02@outlook.com",
                                discordURL: "https://discord.gg/BhdUyCbgkZ",
                                donateURL: "https://paypal.me/xiaonuoya")
        }
        return nil
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ? 150 : 45
    }
    
    override func _returnKeyPressed(_ arg1: Any!) {
        self.view.endEditing(true)
    }

}
