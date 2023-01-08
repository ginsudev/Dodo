//
//  SwiftUIView.swift
//  
//
//  Created by Noah Little on 8/1/2023.
//

import DodoC

final class FlashlightViewModel: ObservableObject {
    @Published var isActiveFlashlight = false {
        didSet {
            toggleFlashlight(enabled: isActiveFlashlight)
            UserDefaults.standard.set(isActiveFlashlight, forKey: "Dodo.isActiveFlashlight")
        }
    }
    
    @Published private(set) var imageName = "flashlight.off.fill"
    
    init() {
        let isActive = UserDefaults.standard.bool(forKey: "Dodo.isActiveFlashlight")
        isActiveFlashlight = isActive
        imageName = isActive ? "flashlight.on.fill" : "flashlight.off.fill"
    }
    
    func toggleFlashlight(enabled: Bool) {
        // Only continue if device has a flashlight
        guard AVFlashlight.hasFlashlight() else {
            return
        }
        
        if enabled {
            SBUIFlashlightController.sharedInstance().turnFlashlightOn(forReason: nil)
            imageName = "flashlight.on.fill"
        } else {
            SBUIFlashlightController.sharedInstance().turnFlashlightOff(forReason: nil)
            imageName = "flashlight.off.fill"
        }
    }
}
