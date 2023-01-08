import Preferences
import Foundation
import dodoC

class DodoWeatherController: DynamicPrefsController {
    override func name() -> String? {
        "dodo"
    }
    
    override func plistName() -> String? {
        "Weather"
    }
}
