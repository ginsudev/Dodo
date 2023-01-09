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
    
    lazy var ringerControl: SBRingerControl? = {
        if let volumeControl = SBVolumeControl.sharedInstance() {
            let ringerControl = Ivars<SBRingerControl>(volumeControl)._ringerControl
            return ringerControl
        } else {
            return nil
        }
    }()
    
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
}

private extension RingerVibrationViewModel {
    func updateVibrationState() {
        let isActiveVibration = TLVibrationManager.shared().shouldVibrateOnRing && TLVibrationManager.shared().shouldVibrateOnSilent
        self.isEnabledVibration = isActiveVibration
    }
    
    @objc func updateRingerState() {
        if let ringerControl {
            self.isEnabledMute = ringerControl.isRingerMuted
        }
    }
}
