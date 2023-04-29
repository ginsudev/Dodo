//
//  AppsManager.swift
//  
//
//  Created by Noah Little on 19/11/2022.
//

import DodoC
import SwiftUI
import GSCore

/// AppsManager
/// Storing app identifiers and shortcuts to opening applications.

final class AppsManager: ObservableObject {
    static let shared = AppsManager()
    
    @Published var favouriteAppBundleIdentifiers: [String] = []
    @Published var suggestedAppBundleIdentifier = PreferenceManager.shared.defaults.string(forKey: Keys.suggestedMediaApp) ?? "com.apple.camera" {
        didSet {
            PreferenceManager.shared.defaults.set(suggestedAppBundleIdentifier, forKey: Keys.suggestedMediaApp)
        }
    }
}

// MARK: - Internal

extension AppsManager {
    func open(app: ApplicationService.App) {
        ApplicationService().open(app: app)
    }
    
    func isInstalled(app: ApplicationService.App) -> Bool {
        var identifier: String {
            switch app {
            case .defined(let defined):
                return defined.rawValue
            case .custom(let identifier):
                return identifier
            @unknown default:
                return ""
            }
        }
        return SBApplicationController.sharedInstance().application(withBundleIdentifier: identifier) != nil
    }
}
