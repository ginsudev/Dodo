//
//  NotificationBridge.swift
//  
//
//  Created by Noah Little on 28/4/2023.
//

import Foundation
import DodoC

final class NotificationBridge {
    enum DarwinNotification: String {
        case ringVibrate = "com.apple.springboard.ring-vibrate.changed"
        case silentVibrate = "com.apple.springboard.silent-vibrate.changed"

        var translatedName: Notification.Name {
            switch self {
            case .ringVibrate:
                return .didChangeRingVibrate
            case .silentVibrate:
                return .didChangeSilentVibrate
            }
        }
    }
    
    private let darwinManager = DarwinNotificationsManager.sharedInstance()
    
    init() {
        addObservers()
    }
    
    deinit {
        darwinManager?.unregister(forNotificationName: DarwinNotification.ringVibrate.rawValue)
        darwinManager?.unregister(forNotificationName: DarwinNotification.silentVibrate.rawValue)
    }
}

private extension NotificationBridge {
    func addObservers() {
        darwinManager?.register(forNotificationName: DarwinNotification.ringVibrate.rawValue, callback: { [weak self] in
            self?.post(.ringVibrate)
        })
        darwinManager?.register(forNotificationName: DarwinNotification.silentVibrate.rawValue, callback: { [weak self] in
            self?.post(.silentVibrate)
        })
    }
    
    func post(_ notification: DarwinNotification) {
        NotificationCenter.default.post(name: notification.translatedName, object: nil)
    }
}
