//
//  Environment+Extensions.swift
//  
//
//  Created by Noah Little on 27/4/2023.
//

import SwiftUI

private struct LockScreenVisibilityKey: EnvironmentKey {
    static let defaultValue = false
}

private struct LandscapeVisibilityKey: EnvironmentKey {
    static let defaultValue = false
}

extension EnvironmentValues {
    var isVisibleLockScreen: Bool {
        get { self[LockScreenVisibilityKey.self] }
        set { self[LockScreenVisibilityKey.self] = newValue }
    }
    
    var isLandscape: Bool {
        get { self[LandscapeVisibilityKey.self] }
        set { self[LandscapeVisibilityKey.self] = newValue }
    }
}
