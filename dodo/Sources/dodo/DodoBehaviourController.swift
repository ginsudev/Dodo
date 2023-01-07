import Preferences
import Foundation
import dodoC

class DodoBehaviourController: DynamicPrefsController {
    override func name() -> String? {
        "dodo"
    }
    
    override func plistName() -> String? {
        "Behaviour"
    }
}
