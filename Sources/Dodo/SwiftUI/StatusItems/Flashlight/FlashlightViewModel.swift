//
//  SwiftUIView.swift
//  
//
//  Created by Noah Little on 8/1/2023.
//

import DodoC

final class FlashlightViewModel: ObservableObject {
    @Published var isActiveFlashlight = PreferenceManager.shared.defaults.bool(forKey: "Dodo.isActiveFlashlight") {
        didSet {
            toggleFlashlight(enabled: isActiveFlashlight)
            PreferenceManager.shared.defaults.set(isActiveFlashlight, forKey: "Dodo.isActiveFlashlight")
        }
    }
    
    var imageName: String {
        isActiveFlashlight ? "flashlight.on.fill" : "flashlight.off.fill"
    }
}

// MARK: - Private

private extension FlashlightViewModel {
    func toggleFlashlight(enabled: Bool) {
        // Only continue if device has a flashlight
        guard AVFlashlight.hasFlashlight() else {
            return
        }
        if enabled {
            SBUIFlashlightController.sharedInstance().turnFlashlightOn(forReason: nil)
        } else {
            SBUIFlashlightController.sharedInstance().turnFlashlightOff(forReason: nil)
        }
        HapticManager.playHaptic(withIntensity: .custom(.medium))
    }
}
