//
//  ResourceBundle.swift
//  
//
//  Created by Noah Little on 27/11/2022.
//

import DodoC

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
