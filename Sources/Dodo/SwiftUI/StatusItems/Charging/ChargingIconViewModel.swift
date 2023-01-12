//
//  ChargingIconViewModel.swift
//  
//
//  Created by Noah Little on 14/12/2022.
//

import UIKit

final class ChargingIconViewModel: ObservableObject {
    @Published private(set) var isCharging: Bool = false
    @Published private(set) var indicationColor: UIColor = .white
    @Published private(set) var imageName: String = "bolt.slash.circle.fill"
    @Published private(set) var batteryPercentage: String = ""
    
    init() {
        guard PreferenceManager.shared.settings.hasChargingIcon || PreferenceManager.shared.settings.hasChargingFlash else {
            return
        }
        addObservers()
        updateChargingStatus()
        updateChargingVisuals()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

// MARK: - Private

private extension ChargingIconViewModel {
    func addObservers() {
        // Enable battery monitoring so that we can recieve battery notifications.
        UIDevice.current.isBatteryMonitoringEnabled = true
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(updateChargingStatus),
            name: UIDevice.batteryStateDidChangeNotification,
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(updateChargingVisuals),
            name: UIDevice.batteryLevelDidChangeNotification,
            object: nil
        )
    }
    
    @objc func updateChargingStatus() {
        DispatchQueue.main.async {
            self.isCharging = UIDevice.current.batteryState != .unplugged
        }
    }
    
    @objc func updateChargingVisuals() {
        let batteryLevel = UIDevice.current.batteryLevel * 100
        
        DispatchQueue.main.async {
            self.indicationColor = UIDevice.current.batteryLevelColorRepresentation()
            self.batteryPercentage = "\(Int(batteryLevel))%"
            switch batteryLevel {
            case 0..<100:
                self.imageName = "bolt.circle.fill"
            default:
                self.imageName = "bolt.slash.circle.fill"
            }
        }
    }
}
