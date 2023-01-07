import Preferences
import Foundation
import dodoC

class DodoFavouriteAppsController: DynamicPrefsController {
    override func name() -> String? {
        "dodo"
    }
    
    override func plistName() -> String? {
        "FavouriteApps"
    }
}
