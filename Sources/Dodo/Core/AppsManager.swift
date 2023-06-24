//
//  AppsManager.swift
//  
//
//  Created by Noah Little on 19/11/2022.
//

import DodoC
import SwiftUI
import GSCore
import Combine

/// AppsManager
/// Storing app identifiers and shortcuts to opening applications.

final class AppsManager: ObservableObject {
    static let shared = AppsManager()
    
    private var bag: Set<AnyCancellable> = []
    
    @Published
    var suggestedAppBundleIdentifier = PreferenceManager.shared.defaults.string(forKey: Keys.suggestedMediaApp) ?? "com.apple.camera"
    
    private init() {
        $suggestedAppBundleIdentifier
            .sink { PreferenceManager.shared.defaults.set($0, forKey: Keys.suggestedMediaApp) }
            .store(in: &bag)
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
