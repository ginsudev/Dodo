//
//  StatusItemGroupView.ViewModel.swift
//  
//
//  Created by Noah Little on 28/4/2023.
//

import Foundation
import UIKit.UIDevice
import Combine

// MARK: - Internal

extension StatusItemGroupView {
    final class ViewModel: ObservableObject {
        private var bag = Set<AnyCancellable>()
        let statusItems: [Settings.StatusItem] = Settings.StatusItem.allCases.filter(\.isEnabled)

        // Seconds
        @Published var secondsString = ""
        
        // Lock
        @Published var lockImageName = "lock.fill"
        
        // Charging
        @Published private(set) var isCharging: Bool = false
        @Published private(set) var chargingIndicationColor: UIColor = .white
        @Published private(set) var chargingImageName: String = "bolt.slash.circle.fill"
        @Published private(set) var batteryPercentage: String = ""
        
        // Vibrate
        @Published var isEnabledVibration = PreferenceManager.shared.defaults.bool(forKey: "Dodo.isActiveVibration") {
            didSet {
                PreferenceManager.shared.defaults.set(isEnabledVibration, forKey: "Dodo.isActiveVibration")
            }
        }
        
        // Ringer
        @Published var isEnabledMute = PreferenceManager.shared.defaults.bool(forKey: "Dodo.isActiveMute") {
            didSet {
                PreferenceManager.shared.defaults.set(isEnabledMute, forKey: "Dodo.isActiveMute")
            }
        }
        
        init() {
            subscribe()
        }
    }
}

// MARK: - Private

private extension StatusItemGroupView.ViewModel {
    func subscribe() {
        // Lock status
        if statusItems.contains(.lockIcon) {
            NotificationCenter.default.publisher(for: .didChangeLockState)
                .receive(on: DispatchQueue.main)
                .sink { [weak self] notification in
                    self?.didChangeLockStatus(notification: notification)
                }
                .store(in: &bag)
        }
        
        // Charging
        if statusItems.contains(.chargingIcon) || PreferenceManager.shared.settings.hasChargingFlash {
            NotificationCenter.default.publisher(for: UIDevice.batteryStateDidChangeNotification)
                .receive(on: DispatchQueue.main)
                .sink { [weak self] _ in
                    self?.updateChargingStatus()
                }
                .store(in: &bag)
            
            NotificationCenter.default.publisher(for: UIDevice.batteryLevelDidChangeNotification)
                .receive(on: DispatchQueue.main)
                .sink { [weak self] _ in
                    self?.updateChargingVisuals()
                }
                .store(in: &bag)
        }
        
        // Seconds
        if statusItems.contains(.seconds) {
            NotificationCenter.default.publisher(for: .refreshContent)
                .receive(on: DispatchQueue.main)
                .sink { [weak self] _ in
                    self?.updateSeconds()
                }
                .store(in: &bag)
        }
        
        // Ringer
        if statusItems.contains(.muted) || statusItems.contains(.vibration) {
            NotificationCenter.default.publisher(for: .didChangeRinger)
                .receive(on: DispatchQueue.main)
                .sink { [weak self] _ in
                    self?.updateRingerState()
                }
                .store(in: &bag)
            
            NotificationCenter.default.publisher(for: .didChangeRingVibrate)
                .receive(on: DispatchQueue.main)
                .sink { [weak self] _ in
                    self?.updateVibrationState()
                }
                .store(in: &bag)
            
            NotificationCenter.default.publisher(for: .didChangeSilentVibrate)
                .receive(on: DispatchQueue.main)
                .sink { [weak self] _ in
                    self?.updateVibrationState()
                }
                .store(in: &bag)
        }
    }
    
    func didChangeLockStatus(notification: Notification) {
        if let info = notification.userInfo,
           let state = info["SBAggregateLockStateKey"] as? Int {
            switch state {
            case 0, 1:
                self.lockImageName = "lock.open.fill"
            default:
                self.lockImageName = "lock.fill"
            }
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
        self.isEnabledMute = PreferenceManager.shared.defaults.bool(forKey: "SBRingerMuted")
    }
    
    func updateVibrationState() {
        // silent-vibrate in SpringBoard stores vibration on/off state for silent mode.
        // ring-vibrate in SpringBoard stores vibration on/off state for ring mode.
        let silentVibrate = PreferenceManager.shared.defaults.bool(forKey: "silent-vibrate")
        let ringVibrate = PreferenceManager.shared.defaults.bool(forKey: "ring-vibrate")
        self.isEnabledVibration = silentVibrate && ringVibrate
    }
}
