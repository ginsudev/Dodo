//
//  RingerVibrationViewModel.swift
//  
//
//  Created by Noah Little on 8/1/2023.
//

import Foundation
import DodoC
import Orion

final class RingerVibrationViewModel: ObservableObject {
    static let shared = RingerVibrationViewModel()
    let darwinManager = DarwinNotificationsManager.sharedInstance()
    
    @Published var isEnabledVibration = UserDefaults.standard.bool(forKey: "Dodo.isActiveVibration") {
        didSet {
            UserDefaults.standard.set(isEnabledVibration, forKey: "Dodo.isActiveVibration")
        }
    }
    
    @Published var isEnabledMute = UserDefaults.standard.bool(forKey: "Dodo.isActiveMute") {
        didSet {
            UserDefaults.standard.set(isEnabledMute, forKey: "Dodo.isActiveMute")
        }
    }
    
    let vibrationImageName: String = {
        if #available(iOS 15, *) {
            return "iphone.radiowaves.left.and.right.circle.fill"
        } else {
            return "waveform.circle.fill"
        }
    }()
    
    let mutedImageName: String = {
        return "speaker.slash.fill"
    }()
    
    init() {
        darwinManager?.register(forNotificationName: "com.apple.springboard.ring-vibrate.changed", callback: { [weak self] in
            self?.updateVibrationState()
        })
        darwinManager?.register(forNotificationName: "com.apple.springboard.silent-vibrate.changed", callback: { [weak self] in
            self?.updateVibrationState()
        })
    }
    
    private func updateVibrationState() {
        let isActiveVibration = TLVibrationManager.shared().shouldVibrateOnRing && TLVibrationManager.shared().shouldVibrateOnSilent
        self.isEnabledVibration = isActiveVibration
    }
}
