//
//  Dimensions.swift
//  
//
//  Created by Noah Little on 21/12/2022.
//

import UIKit
import SwiftUI
import DodoC

enum GridSizeType: Int {
    case flexible = 0
    case fixed = 1
}

final class Dimensions: ObservableObject {
    static let shared = Dimensions()
    @Published var isLandscape: Bool = false
    
    var height: CGFloat = 0.0 {
        didSet {
            NotificationCenter.default.post(
                name: NSNotification.Name("Dodo.didUpdateHeight"),
                object: nil
            )
        }
    }
    
    let androBarHeight: CGFloat = {
        GSUtilities.sharedInstance().isAndroBarInstalled()
        ? GSUtilities.sharedInstance().androBarHeight
        : 0
    }()
    
    let statusItemHeight: CGFloat = 18.0
    var favouriteAppsGridSizeType: GridSizeType = .flexible
    var favouriteAppsFlexibleGridItemSize: Double = 40.0
    var favouriteAppsFlexibleGridColumnAmount: Int = 3
    var favouriteAppsFixedGridItemSize: Double = 40.0
    var favouriteAppsFixedGridColumnAmount: Int = 3
}

extension Dimensions {
    struct Padding {
        /// 10px
        static let medium = 10.0
        /// 12px
        static let system = 12.0
    }
}
