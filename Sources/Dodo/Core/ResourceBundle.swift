//
//  ResourceBundle.swift
//  
//
//  Created by Noah Little on 27/11/2022.
//

import DodoC

enum LocalisedText {
    case recommended
    case bluetooth
    case tap
    
    func text() -> String {
        switch self {
        case .recommended:
            return ResourceBundle.localisation(for: "Recommended_For_You")
        case .bluetooth:
            return ResourceBundle.localisation(for: "Bluetooth")
        case .tap:
            return ResourceBundle.localisation(for: "Tap_To_Listen")
        }
    }
}

struct ResourceBundle {
    private static let bundle = Bundle(
        path: GSUtilities.sharedInstance().correctedFilePathFromPath(
            withRootPrefix: ":root:Library/Application Support/Dodo/Dodo.bundle"
        )
    )
    
    static func localisation(for text: String) -> String {
        guard let bundle else {
            return text
        }
        return bundle.localizedString(forKey: text, value: nil, table: nil)
    }
}
