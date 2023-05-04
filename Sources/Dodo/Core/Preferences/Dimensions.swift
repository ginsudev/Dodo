//
//  Dimensions.swift
//  
//
//  Created by Noah Little on 21/12/2022.
//

import SwiftUI
import DodoC
import GSCore

final class Dimensions: ObservableObject {
    static let shared = Dimensions()
    @Published var isLandscape = false
    @Published var isVisibleLockScreen = true

    var dodoFrame: CGRect = .zero
    
    var androBarHeight = AndroBar().barHeight
    
    var statusItemSize: CGSize = .init(
        width: 18.0,
        height: 18.0
    )
    
    var favouriteAppsGridSizeType: Settings.GridSizeType = .flexible
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
