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
        private static let dateComponentsFormatter: DateComponentsFormatter = {
            let formatter = DateComponentsFormatter()
            formatter.allowedUnits = [.hour, .minute, .second]
            formatter.unitsStyle = .positional
            formatter.zeroFormattingBehavior = .pad
            return formatter
        }()
        
        let statusItems: [Settings.StatusItem] = Settings.StatusItem.allCases.filter(\.isEnabled)
        let settings = PreferenceManager.shared.settings.statusItems
        
        // MARK: Timer countdown
        @Published
        private(set) var timerRemainingTime = ""

        // MARK: Seconds
        @Published
        private(set) var secondsString = ""
        
        // MARK: Lock
        @Published
        private(set) var isLocked = false
        
        // MARK: Charging
        @Published
        private(set) var isCharging: Bool = false
        
        @Published
        private(set) var chargingIndicationColor: UIColor = .white
        
        @Published
        private(set) var chargingImageName: String = "bolt.slash.circle.fill"
        
        @Published
        private(set) var batteryPercentage: String = ""
        
        // MARK: Vibrate
        @Published
        var isEnabledVibration = PreferenceManager.shared.defaults.bool(forKey: Keys.isActiveVibration) {
            didSet {
                PreferenceManager.shared.defaults.set(isEnabledVibration, forKey: Keys.isActiveVibration)
            }
        }
        
        // MARK: Ringer
        @Published
        var isEnabledMute = PreferenceManager.shared.defaults.bool(forKey: Keys.isActiveMute) {
            didSet {
                PreferenceManager.shared.defaults.set(isEnabledMute, forKey: Keys.isActiveMute)
            }
        }
        
        // MARK: Flashlight
        @Published
        var isActiveFlashlight = PreferenceManager.shared.defaults.bool(forKey: Keys.isActiveFlashlight) {
            didSet {
                toggleFlashlight(enabled: isActiveFlashlight)
                PreferenceManager.shared.defaults.set(isActiveFlashlight, forKey: Keys.isActiveFlashlight)
            }
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
        
        func updateTimerRemainingTime(interval: TimeInterval?) {
            guard let interval else {
                self.timerRemainingTime = ""
                return
            }
            
            self.timerRemainingTime = Self.dateComponentsFormatter.string(from: interval) ?? ""
        }
        
        func updateSeconds() {
            self.secondsString = Formatters.seconds.string(from: Date())
        }
        
        func didChangeRingerState(notification: Notification) {
            // SBRingerMuted in SpringBoard stores ringer on/off state.
            guard let userInfo = notification.userInfo,
                  let isMuted = userInfo["isMuted"] as? Bool
            else { return }
            self.isEnabledMute = isMuted
        }
        
        func updateVibrationState() {
            // silent-vibrate in SpringBoard stores vibration on/off state for silent mode.
            // ring-vibrate in SpringBoard stores vibration on/off state for ring mode.
            let silentVibrate = PreferenceManager.shared.defaults.bool(forKey: Keys.silentVibrate)
            let ringVibrate = PreferenceManager.shared.defaults.bool(forKey: Keys.ringVibrate)
            self.isEnabledVibration = silentVibrate && ringVibrate && !UIDevice.currentIsIPad()
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
