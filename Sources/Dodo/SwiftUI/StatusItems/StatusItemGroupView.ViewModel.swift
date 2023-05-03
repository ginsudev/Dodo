//
//  StatusItemGroupView.ViewModel.swift
//  
//
//  Created by Noah Little on 28/4/2023.
//

import Foundation
import UIKit.UIDevice
import DodoC

// MARK: - Internal

extension StatusItemGroupView {
    final class ViewModel: ObservableObject {
        let statusItems: [Settings.StatusItem] = Settings.StatusItem.allCases.filter(\.isEnabled)

        // Seconds
        @Published var secondsString = ""
        
        // Lock
        @Published var isLocked = false
        
        // Charging
        @Published private(set) var isCharging: Bool = false
        @Published private(set) var chargingIndicationColor: UIColor = .white
        @Published private(set) var chargingImageName: String = "bolt.slash.circle.fill"
        @Published private(set) var batteryPercentage: String = ""
        
        // Vibrate
        @Published var isEnabledVibration = PreferenceManager.shared.defaults.bool(forKey: Keys.isActiveVibration) {
            didSet {
                PreferenceManager.shared.defaults.set(isEnabledVibration, forKey: Keys.isActiveVibration)
            }
        }
        
        // Ringer
        @Published var isEnabledMute = PreferenceManager.shared.defaults.bool(forKey: Keys.isActiveMute) {
            didSet {
                PreferenceManager.shared.defaults.set(isEnabledMute, forKey: Keys.isActiveMute)
            }
        }
        
        // Flashlight
        @Published var isActiveFlashlight = PreferenceManager.shared.defaults.bool(forKey: Keys.isActiveFlashlight) {
            didSet {
                toggleFlashlight(enabled: isActiveFlashlight)
                PreferenceManager.shared.defaults.set(isActiveFlashlight, forKey: Keys.isActiveFlashlight)
            }
        }
        
        init() {
        }
        
        func didChangeLockStatus(notification: Notification) {
            if let info = notification.userInfo,
               let state = info["SBAggregateLockStateKey"] as? Int {
                isLocked = !(0...1).contains(state)
            }
        }
        
        func updateChargingStatus() {
            self.isCharging = UIDevice.current.batteryState != .unplugged
        }
        
        func updateChargingVisuals() {
            let batteryLevel = UIDevice.current.batteryLevel * 100
            self.chargingIndicationColor = UIDevice.current.batteryLevelColorRepresentation
            self.batteryPercentage = "\(Int(batteryLevel))%"
            switch batteryLevel {
            case 0..<100:
                self.chargingImageName = "bolt.circle.fill"
            default:
                self.chargingImageName = "bolt.slash.circle.fill"
            }
        }
        
        func updateSeconds() {
            self.secondsString = Formatters.seconds.string(from: Date())
        }
        
        func updateRingerState() {
            // SBRingerMuted in SpringBoard stores ringer on/off state.
            self.isEnabledMute = PreferenceManager.shared.defaults.bool(forKey: Keys.sbRingerMuted)
        }
        
        func updateVibrationState() {
            // silent-vibrate in SpringBoard stores vibration on/off state for silent mode.
            // ring-vibrate in SpringBoard stores vibration on/off state for ring mode.
            let silentVibrate = PreferenceManager.shared.defaults.bool(forKey: Keys.silentVibrate)
            let ringVibrate = PreferenceManager.shared.defaults.bool(forKey: Keys.ringVibrate)
            self.isEnabledVibration = silentVibrate && ringVibrate
        }
        
        func toggleFlashlight(enabled: Bool) {
            // Only continue if device has a flashlight
            guard AVFlashlight.hasFlashlight() else { return }
            if enabled {
                SBUIFlashlightController.sharedInstance().turnFlashlightOn(forReason: nil)
            } else {
                SBUIFlashlightController.sharedInstance().turnFlashlightOff(forReason: nil)
            }
            HapticManager.playHaptic(withIntensity: .custom(.medium))
        }
    }
}
