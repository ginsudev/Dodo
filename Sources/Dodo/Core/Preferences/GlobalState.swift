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
    @Published var isScreenOff = false {
        didSet {
            NotificationCenter.default.post(name: .refreshOnceContent, object: nil)
        }
    }
    var dodoFrame: CGRect = .zero
}
