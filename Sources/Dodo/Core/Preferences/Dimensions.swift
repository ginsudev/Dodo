//
//  GlobalState.swift
//
//
//  Created by Noah Little on 21/12/2022.
//

import Foundation

final class GlobalState: ObservableObject {
    static let shared = GlobalState()
    @Published var isLandscape = false
    @Published var isVisibleLockScreen = false
    var dodoFrame: CGRect = .zero
}
