import Preferences
import Foundation
import dodoC

class DodoStatusItemsController: DynamicPrefsController {
    override func name() -> String? {
        "dodo"
    }
    
    override func plistName() -> String? {
        "StatusItems"
    }
}
