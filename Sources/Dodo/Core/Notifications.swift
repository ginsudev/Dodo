//
//  Notifications.swift
//  
//
//  Created by Noah Little on 13/1/2023.
//

import Foundation

/// Notifications
/// A collection of system notifications tightly packed together in one place.
enum Notifications {
    /// Vibration on ringer state changed notification.
    static let cf_ringVibrate = "com.apple.springboard.ring-vibrate.changed"
    /// Vibration on silent state changed notification.
    static let cf_silentVibrate = "com.apple.springboard.silent-vibrate.changed"
    /// Lock screen did dismiss notification
    static let cf_lockScreenDidDismiss = "com.apple.springboardservices.eventobserver.internalSBSEventObserverEventContinuityUIWasObscured"
    /// Lock screen did appear notification
    static let cf_lockScreenDidAppear = "com.apple.springboardservices.eventobserver.internalSBSEventObserverEventContinuityUIBecameVisible"
    /// Ringer enabled state changed notification.
    static let nc_ringerChanged = "SBRingerChangedNotification"
    /// Lock state changed notification.
    static let nc_lockStateDidChange = "SBAggregateLockStateDidChangeNotification"
    /// Media is playing did change notification.
    static let nc_didChangeIsPlaying = "kMRMediaRemoteOriginNowPlayingApplicationIsPlayingDidChangeNotification"
    /// Media info did change notification.
    static let nc_didChangeNowPlayingInfo = "kMRMediaRemotePlayerNowPlayingInfoDidChangeNotification"
}

extension Notification.Name {
    static let RefreshContent = Notification.Name("Dodo.RefreshContent")
    static let RefreshOnceContent = Notification.Name("Dodo.RefreshOnceContent")
}
