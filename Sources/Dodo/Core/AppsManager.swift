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

final class AppsManager: ObservableObject {
    static let shared = AppsManager()
    
    @Published var favouriteAppBundleIdentifiers = [String]()
    
    @Published var suggestedAppBundleIdentifier = "com.apple.camera" {
        didSet {
            PreferenceManager.shared.defaults.set(
                suggestedAppBundleIdentifier,
                forKey: "Dodo.SuggestedMediaApp"
            )
        }
    }
    
    init() {
        if let identifier = PreferenceManager.shared.defaults.string(
            forKey: "Dodo.SuggestedMediaApp"
        ) {
            suggestedAppBundleIdentifier = identifier
        }
    }
}

// MARK: - Internal

extension AppsManager {
    enum DefinedApp: String {
        case weather = "com.apple.weather"
        case clock = "com.apple.mobiletimer"
    }
    
    enum App {
        case defined(DefinedApp)
        case custom(String)
    }
    
    func open(app: App) {
        guard let service = FBSSystemService.shared() else {
            return
        }
        let launchOptions = [
            FBSOpenApplicationOptionKeyPromptUnlockDevice: NSNumber(value: 1),
            FBSOpenApplicationOptionKeyUnlockDevice: NSNumber(value: 1)
        ]
        
        var identifier: String {
            switch app {
            case .defined(let defined):
                return defined.rawValue
            case .custom(let identifier):
                return identifier
            }
        }
        
        service.openApplication(
            identifier,
            options: launchOptions,
            withResult: nil
        )
    }
    
    func isInstalled(app: App) -> Bool {
        var identifier: String {
            switch app {
            case .defined(let defined):
                return defined.rawValue
            case .custom(let identifier):
                return identifier
            }
        }
        return SBApplicationController.sharedInstance().application(withBundleIdentifier: identifier) != nil
    }
}
