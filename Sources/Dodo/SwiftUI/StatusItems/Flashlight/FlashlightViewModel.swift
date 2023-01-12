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
            PreferenceManager.shared.defaults.set(isActiveFlashlight, forKey: "Dodo.isActiveFlashlight")
        }
    }
    
    @Published private(set) var imageName = "flashlight.off.fill"
    
    init() {
        let isActive = PreferenceManager.shared.defaults.bool(forKey: "Dodo.isActiveFlashlight")
        isActiveFlashlight = isActive
        imageName = isActive ? "flashlight.on.fill" : "flashlight.off.fill"
    }
}

// MARK: - Private

private extension FlashlightViewModel {
    func toggleFlashlight(enabled: Bool) {
        // Only continue if device has a flashlight
        guard AVFlashlight.hasFlashlight() else {
            return
        }
        
        var name: String
        
        if enabled {
            SBUIFlashlightController.sharedInstance().warmUp()
            SBUIFlashlightController.sharedInstance().turnFlashlightOn(forReason: nil)
            name = "flashlight.on.fill"
        } else {
            SBUIFlashlightController.sharedInstance().turnFlashlightOff(forReason: nil)
            name = "flashlight.off.fill"
        }
        
        DispatchQueue.main.async { [weak self] in
            self?.imageName = name
        }
    }
}
