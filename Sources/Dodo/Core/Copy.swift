//
//  ResourceBundle.swift
//  
//
//  Created by Noah Little on 27/11/2022.
//

import DodoC
import GSCore

enum Copy {
    enum Media {
        static let recommended = "Recommended_For_You".localize(bundle: .dodo)
        static let bluetooth = "Bluetooth".localize(bundle: .dodo)
        static let tap = "Tap_To_Listen".localize(bundle: .dodo)
    }
    
    enum Weather {
        static func highLow(_ high: String, _ low: String) -> String {
            String(format: "High_Low".localize(bundle: .dodo), high, low)
        }
    }
}
