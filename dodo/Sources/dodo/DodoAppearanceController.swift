import Preferences
import Foundation
import dodoC

class DodoAppearanceController: DynamicPrefsController {
    override func name() -> String? {
        "dodo"
    }
    
    override func plistName() -> String? {
        "Appearance"
    }
}
