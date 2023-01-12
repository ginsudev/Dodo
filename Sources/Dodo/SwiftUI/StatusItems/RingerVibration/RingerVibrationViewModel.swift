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
    let darwinManager = DarwinNotificationsManager.sharedInstance()
    
    @Published var isEnabledVibration = PreferenceManager.shared.defaults.bool(forKey: "Dodo.isActiveVibration") {
        didSet {
            PreferenceManager.shared.defaults.set(isEnabledVibration, forKey: "Dodo.isActiveVibration")
        }
    }
    
    @Published var isEnabledMute = PreferenceManager.shared.defaults.bool(forKey: "Dodo.isActiveMute") {
        didSet {
            PreferenceManager.shared.defaults.set(isEnabledMute, forKey: "Dodo.isActiveMute")
        }
    }
    
    let vibrationImageName = {
        if #available(iOS 15, *) {
            return "iphone.radiowaves.left.and.right.circle.fill"
        } else {
            return "waveform.circle.fill"
        }
    }()
    
    let mutedImageName = "speaker.slash.fill"
    
    init() {
        darwinManager?.register(forNotificationName: "com.apple.springboard.ring-vibrate.changed", callback: { [weak self] in
            self?.updateVibrationState()
        })
        darwinManager?.register(forNotificationName: "com.apple.springboard.silent-vibrate.changed", callback: { [weak self] in
            self?.updateVibrationState()
        })
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(updateRingerState),
            name: NSNotification.Name("SBRingerChangedNotification"),
            object: nil
        )
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

private extension RingerVibrationViewModel {
    func updateVibrationState() {
        // silent-vibrate in SpringBoard stores vibration on/off state for silent mode.
        // ring-vibrate in SpringBoard stores vibration on/off state for ring mode.
        let silentVibrate = PreferenceManager.shared.defaults.bool(forKey: "silent-vibrate")
        let ringVibrate = PreferenceManager.shared.defaults.bool(forKey: "ring-vibrate")
        DispatchQueue.main.async {
            self.isEnabledVibration = silentVibrate && ringVibrate
        }
    }
    
    @objc func updateRingerState() {
        DispatchQueue.main.async {
            // SBRingerMuted in SpringBoard stores ringer on/off state.
            self.isEnabledMute = PreferenceManager.shared.defaults.bool(forKey: "SBRingerMuted")
        }
    }
}
