//
//  HapticManager.swift
//  
//
//  Created by Noah Little on 26/11/2022.
//

import UIKit

enum HapticIntensity {
    case success, thud, custom(UIImpactFeedbackGenerator.FeedbackStyle)
}

struct HapticManager {
    static func playHaptic(withIntensity intensity: HapticIntensity) {
        var generator: UIFeedbackGenerator
        
        switch intensity {
        case .success:
            generator = UINotificationFeedbackGenerator()
            generator.prepare()
            (generator as! UINotificationFeedbackGenerator).notificationOccurred(.success)
            break;
        case .thud:
            generator = UIImpactFeedbackGenerator(style: .heavy)
            generator.prepare()
            (generator as! UIImpactFeedbackGenerator).impactOccurred()
            break;
        case .custom(let feedbackStyle):
            generator = UIImpactFeedbackGenerator(style: feedbackStyle)
            generator.prepare()
            (generator as! UIImpactFeedbackGenerator).impactOccurred()
            break;
        }
    }
}
