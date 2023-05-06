//
//  Bundle+Dodo.swift
//  
//
//  Created by Noah Little on 6/5/2023.
//

import Foundation
import GSCore

extension Bundle {
    static var dodo: Bundle {
        if let bundle = Bundle(path: "/Library/PreferenceBundles/dodo.bundle/".rootify) {
            return bundle
        } else {
            return .main
        }
    }
}
