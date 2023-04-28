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
        case lockScreenDidDismiss = "com.apple.springboardservices.eventobserver.internalSBSEventObserverEventContinuityUIWasObscured"
        case lockScreenDidAppear = "com.apple.springboardservices.eventobserver.internalSBSEventObserverEventContinuityUIBecameVisible"

        var translatedName: Notification.Name {
            switch self {
            case .ringVibrate:
                return .didChangeRingVibrate
            case .silentVibrate:
                return .didChangeSilentVibrate
            case .lockScreenDidDismiss:
                return .didDismissLockScreen
            case .lockScreenDidAppear:
                return .didAppearLockScreen
            }
        }
    }
    
    private let darwinManager = DarwinNotificationsManager.sharedInstance()
    
    init() {
        addObservers()
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
        darwinManager?.register(forNotificationName: DarwinNotification.lockScreenDidDismiss.rawValue, callback: { [weak self] in
            self?.post(.lockScreenDidDismiss)
        })
        darwinManager?.register(forNotificationName: DarwinNotification.lockScreenDidAppear.rawValue, callback: { [weak self] in
            self?.post(.lockScreenDidAppear)
        })
    }
    
    func post(_ notification: DarwinNotification) {
        NotificationCenter.default.post(name: notification.translatedName, object: nil)
    }
}
