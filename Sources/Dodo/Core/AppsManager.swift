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
            }
        }
        return SBApplicationController.sharedInstance().application(withBundleIdentifier: identifier) != nil
    }
}
