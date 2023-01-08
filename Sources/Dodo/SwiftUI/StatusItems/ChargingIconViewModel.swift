//
//  ChargingIconViewModel.swift
//  
//
//  Created by Noah Little on 14/12/2022.
//

import UIKit
import SwiftUI

@MainActor
final class ChargingIconViewModel: ObservableObject {
    @Published private(set) var isCharging: Bool = false
    @Published private(set) var indicationColor: Color = .white
    @Published private(set) var imageName: String = "bolt.slash.circle.fill"
    
    init() {
        guard PreferenceManager.shared.settings.hasChargingIcon || PreferenceManager.shared.settings.hasChargingFlash else {
            return
        }
        addObservers()
        updateChargingStatus()
        updateChargingColor()
    }
    
    private func addObservers() {
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
            selector: #selector(updateChargingColor),
            name: UIDevice.batteryLevelDidChangeNotification,
            object: nil
        )
    }
    
    @objc private func updateChargingStatus() {
        isCharging = UIDevice.current.batteryState != .unplugged
    }
    
    @objc private func updateChargingColor() {
        let batteryLevel = UIDevice.current.batteryLevel * 100
        
        switch batteryLevel {
        case 0..<20:
            indicationColor = .red
            imageName = "bolt.circle.fill"
        case 20..<80:
            indicationColor = .yellow
            imageName = "bolt.circle.fill"
        case 80..<100:
            indicationColor = .green
            imageName = "bolt.circle.fill"
        default:
            indicationColor = .green
            imageName = "bolt.slash.circle.fill"
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
