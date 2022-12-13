//
//  AppsManager.swift
//  
//
//  Created by Noah Little on 19/11/2022.
//

import DodoC
import SwiftUI

/// AppsManager
/// Storing app identifiers and shortcuts to opening applications.

struct AppsManager {
    static func openApplication(withIdentifier identifier: String) {
        guard let service = FBSSystemService.shared() else {
            return
        }
        let launchOptions = [
            FBSOpenApplicationOptionKeyPromptUnlockDevice: NSNumber(value: 1),
            FBSOpenApplicationOptionKeyUnlockDevice: NSNumber(value: 1)
        ]
        service.openApplication(
            identifier,
            options: launchOptions,
            withResult: nil
        )
    }
    
    static var suggestedAppBundleIdentifier: String {
        get {
            guard let identifier = UserDefaults.standard.string(
                forKey: "Dodo.SuggestedMediaApp"
            ) else {
                return "com.apple.camera"
            }
            return identifier
        }
        set {
            UserDefaults.standard.set(
                newValue,
                forKey: "Dodo.SuggestedMediaApp"
            )
        }
    }
    
    static var favouriteAppBundleIdentifiers = [
        "com.apple.camera",
        "com.apple.Preferences",
        "com.apple.MobileSMS",
        "com.apple.mobilemail"
    ]
}
