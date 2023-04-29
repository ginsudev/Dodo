//
//  Notifications.swift
//  
//
//  Created by Noah Little on 13/1/2023.
//

import Foundation

extension Notification.Name {
    // Refresh
    static let refreshContent = Notification.Name("Dodo.RefreshContent")
    static let refreshOnceContent = Notification.Name("Dodo.RefreshOnceContent")
    static let didUpdateHeight = Notification.Name("Dodo.didUpdateHeight")
    
    // Ringer
    /// Vibration on ringer state changed notification.
    static let didChangeRingVibrate = Notification.Name("Dodo.DidChangeRingVibrate")
    /// Vibration on silent state changed notification.
    static let didChangeSilentVibrate = Notification.Name("Dodo.DidChangeSilentVibrate")
    /// Ringer enabled state changed notification.
    static let didChangeRinger = Notification.Name("SBRingerChangedNotification")
    
    // Lockscreen
    /// Lock screen did dismiss notification
    static let didDismissLockScreen = Notification.Name("Dodo.DidDismissLockScreen")
    /// Lock screen did appear notification
    static let didAppearLockScreen = Notification.Name("Dodo.DidAppearLockScreen")
    /// Lock state changed notification.
    static let didChangeLockState = Notification.Name("SBAggregateLockStateDidChangeNotification")
    
    // Media
    /// Media is playing did change notification.
    static let didChangeIsPlaying = Notification.Name("kMRMediaRemoteOriginNowPlayingApplicationIsPlayingDidChangeNotification")
    /// Media info did change notification.
    static let didChangeNowPlayingInfo = Notification.Name("kMRMediaRemotePlayerNowPlayingInfoDidChangeNotification")
}

extension Notification {
    /// A dummy notification to fake-emit a value to combine publishers before actual values are recieved.
    static let prepended: Self = .init(name: Name("Dodo.Combine.Prepended"))
}
