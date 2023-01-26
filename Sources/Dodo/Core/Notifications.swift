//
//  Notifications.swift
//  
//
//  Created by Noah Little on 13/1/2023.
//

import Foundation

/// Notifications
/// A collection of system notifications tightly packed together in one place.
struct Notifications {
    /// Vibration on ringer state changed notification.
    static var cf_ringVibrate = "com.apple.springboard.ring-vibrate.changed"
    /// Vibration on silent state changed notification.
    static var cf_silentVibrate = "com.apple.springboard.silent-vibrate.changed"
    /// Lock screen did dismiss notification
    static var nc_didDismissLockScreen = "SBCoverSheetDidDismissNotification"
    /// Lock screen did appear notification
    static var nc_didPresentLockScreen = "SBCoverSheetDidPresentNotification"
    /// Lock screen did undim notification.
    static var nc_didUndimLockScreen = "SBLockScreenUndimmedNotification"
    /// Lock screen did dim notification
    static var nc_didDimLockScreen = "SBLockScreenDimmedNotification"
    /// Ringer enabled state changed notification.
    static var nc_ringerChanged = "SBRingerChangedNotification"
    /// Lock state changed notification.
    static var nc_lockStateDidChange = "SBAggregateLockStateDidChangeNotification"
    /// Media is playing did change notification.
    static var nc_didChangeIsPlaying = "kMRMediaRemoteOriginNowPlayingApplicationIsPlayingDidChangeNotification"
    /// Media info did change notification.
    static var nc_didChangeNowPlayingInfo = "kMRMediaRemotePlayerNowPlayingInfoDidChangeNotification"
}

/*
 SBLockScreenUndimmedNotification
 SBLockScreenDimmedNotification
 SBCoverSheetDidPresentNotification
 SBCoverSheetDidDismissNotification
 */
