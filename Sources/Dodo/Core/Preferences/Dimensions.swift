//
//  Dimensions.swift
//  
//
//  Created by Noah Little on 21/12/2022.
//

import SwiftUI
import DodoC

enum GridSizeType: Int {
    case flexible = 0
    case fixed = 1
    case adaptive = 2
}

final class Dimensions: ObservableObject {
    static let shared = Dimensions()
    @Published var isLandscape = false
    @Published var isVisibleLockScreen = false
    
    var dodoFrame: CGRect = .zero
    
    let androBarHeight: CGFloat = {
        GSUtilities.sharedInstance().isAndroBarInstalled()
        ? GSUtilities.sharedInstance().androBarHeight
        : 0
    }()
    
    var statusItemSize: CGSize = .init(
        width: 18.0,
        height: 18.0
    )
    
    var favouriteAppsGridSizeType: GridSizeType = .flexible
    var favouriteAppsFlexibleGridItemSize: Double = 40.0
    var favouriteAppsFlexibleGridColumnAmount: Int = 3
    var favouriteAppsFixedGridItemSize: Double = 40.0
    var favouriteAppsFixedGridColumnAmount: Int = 3
}

extension Dimensions {
    struct Padding {
        /// 8px
        static let small = 8.0
        /// 10px
        static let medium = 10.0
        /// 12px
        static let system = 12.0
    }
}
