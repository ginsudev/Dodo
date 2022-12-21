import Preferences
import Foundation
import dodoC

class DodoBehaviourController: PSListController {
    private var name = "dodo"

    override var specifiers: NSMutableArray? {
        get {
            if let specifiers = value(forKey: "_specifiers") as? NSMutableArray {
                self.collectDynamicSpecifiersFromArray(specifiers as! [PSSpecifier])
                return specifiers
            } else {
                let specifiers = loadSpecifiers(fromPlistName: "Behaviour", target: self)
                setValue(specifiers, forKey: "_specifiers")
                self.collectDynamicSpecifiersFromArray(specifiers as! [PSSpecifier])
                return specifiers
            }
        }
        set {
            super.specifiers = newValue
        }
    }
    
    private var hasDynamicSpecifiers = false
    private var dynamicSpecifiers = [String : [PSSpecifier]]()
    private var hiddenSpecifiers = Set<PSSpecifier>()
    
    override func reloadSpecifiers() {
        super.reloadSpecifiers()
        self.collectDynamicSpecifiersFromArray(self.specifiers as! [PSSpecifier])
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let currentSpecifier = specifier(at: indexPath) else {
            return UITableView.automaticDimension
        }
        
        let originalCellHeight = currentSpecifier.property(forKey: "height") as? CGFloat
        ?? UITableView.automaticDimension
        
        guard hasDynamicSpecifiers else {
            return originalCellHeight
        }
        
        for (_, specifierArray) in dynamicSpecifiers {
            if specifierArray.contains(currentSpecifier) {
                
                let shouldHide = shouldHideSpecifier(currentSpecifier)
                
                guard let cell = currentSpecifier.property(forKey: PSTableCellKey) as? UITableViewCell else {
                    continue
                }
                
                cell.clipsToBounds = shouldHide
                
                if shouldHide {
                    hiddenSpecifiers.insert(currentSpecifier)
                    return 0
                } else {
                    hiddenSpecifiers.remove(currentSpecifier)
                    return originalCellHeight
                }
                
            } else if hiddenSpecifiers.contains(currentSpecifier) {
                hiddenSpecifiers.remove(currentSpecifier)
            }
        }
        
        return originalCellHeight
    }
    
    func shouldHideSpecifier(_ specifier: PSSpecifier) -> Bool {
        let dynamicSpecifierRule = specifier.property(
            forKey: "dynamicRule"
        ) as! String
        
        let dynamicSpecifierComponents = dynamicSpecifierRule.components(
            separatedBy: ","
        )
        
        // Return true early if the control specifier is already hidden.
        if hiddenSpecifiers.contains(
            where: {($0.property(forKey: PSIDKey) as? String ?? "") == dynamicSpecifierComponents[0]}
        ) {
            return true
        }
        
        guard let comparator = GSPrefsComparator(
            rawValue: dynamicSpecifierComponents[1]
        ) else {
            return false
        }
        
        guard let dynamicSpecifierRequiredValue = Int(dynamicSpecifierComponents.last!) else {
            return false
        }
        
        guard let controlSpecifier = self.specifier(
            forID: dynamicSpecifierComponents.first
        ) else {
            return false
        }
        
        guard let controlSpecifierValue = self.readPreferenceValue(controlSpecifier) as? Int else {
            return false
        }
        
        switch comparator {
        case .equals:
            return dynamicSpecifierRequiredValue == controlSpecifierValue
        case .notEqualTo:
            return dynamicSpecifierRequiredValue != controlSpecifierValue
        case .lessThanOrEqualTo:
            return dynamicSpecifierRequiredValue <= controlSpecifierValue
        case .lessThan:
            return dynamicSpecifierRequiredValue < controlSpecifierValue
        case .greaterThanOrEqualTo:
            return dynamicSpecifierRequiredValue >= controlSpecifierValue
        case .greaterThan:
            return dynamicSpecifierRequiredValue > controlSpecifierValue
        }
    }
    
    func collectDynamicSpecifiersFromArray(_ array: [PSSpecifier]) {
        if !self.dynamicSpecifiers.isEmpty {
            self.dynamicSpecifiers.removeAll()
        }
        
        var dynamicSpecifiersArray = [PSSpecifier]()
        
        //Append specifiers that have a dynamic rule to dynamicSpecifiersArray.
        for specifier in array {
            if let dynamicSpecifierRule = specifier.property(forKey: "dynamicRule") as? String, dynamicSpecifierRule.count > 0 {
                dynamicSpecifiersArray.append(specifier)
            }
        }
        
        let groupedDict = Dictionary(
            grouping: dynamicSpecifiersArray,
            by: {
                ($0.property(forKey: "dynamicRule") as! String)
                    .components(separatedBy: ",")
                    .first!
            }
        )
        
        for (key, value) in groupedDict {
            dynamicSpecifiers[key] = value
        }
        
        self.hasDynamicSpecifiers = self.dynamicSpecifiers.count > 0
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.table.keyboardDismissMode = .onDrag

        let applyButton = GSRespringButton()
        self.navigationItem.rightBarButtonItem = applyButton
    }
    
    override func readPreferenceValue(_ specifier: PSSpecifier!) -> Any! {
        var propertyListFormat =  PropertyListSerialization.PropertyListFormat.xml
        
        let plistURL = URL(fileURLWithPath: "/var/mobile/Library/Preferences/com.ginsu.\(name).plist")

        guard let plistXML = try? Data(contentsOf: plistURL) else {
            return specifier.properties["default"]
        }
        
        guard let plistDict = try! PropertyListSerialization.propertyList(
            from: plistXML,
            options: .mutableContainersAndLeaves,
            format: &propertyListFormat
        ) as? [String : AnyObject] else {
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
        
        guard var plistDict = try! PropertyListSerialization.propertyList(
            from: plistXML,
            options: .mutableContainersAndLeaves,
            format: &propertyListFormat
        ) as? [String : AnyObject] else {
            return
        }
    
        plistDict[specifier.properties["key"] as! String] = value! as AnyObject
        
        do {
            let newData = try PropertyListSerialization.data(
                fromPropertyList: plistDict,
                format: propertyListFormat,
                options: 0
            )
            try newData.write(to: plistURL)
        } catch {
            return
        }
        
        if hasDynamicSpecifiers {
            if let specifierID = specifier.property(forKey: PSIDKey) as? String, self.dynamicSpecifiers[specifierID] != nil {
                self.table.reloadData()
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.reloadSpecifiers()
        self.table.reloadData()
    }
    
    override func tableViewStyle() -> UITableView.Style {
        guard #available(iOS 13.0, *) else {
            return .grouped
        }
        return .insetGrouped
    }
    
    override func _returnKeyPressed(_ arg1: Any!) {
        self.view.endEditing(true)
    }
}
