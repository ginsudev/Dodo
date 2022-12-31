//
//  MediaPlayerStyle.swift
//  
//
//  Created by Noah Little on 20/11/2022.
//

import Foundation
import SwiftUI

enum MediaPlayerStyle: Int {
    case modular = 0
    case classic = 1
    
    func cornerRadius() -> CGFloat {
        switch self {
        case .modular:
            return UIDevice._hasHomeButton() ? 8 : 15.0
        case .classic:
            return 0.0
        }
    }
    
    func artworkRadius() -> CGFloat {
        switch self {
        case .modular:
            return cornerRadius() - Dimensions.Padding.medium
        case .classic:
            return 5
        }
    }
}
