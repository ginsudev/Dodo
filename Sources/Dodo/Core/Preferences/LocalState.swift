//
//  GlobalState.swift
//
//
//  Created by Noah Little on 21/12/2022.
//

import Foundation
import GSCore

final class LocalState: ObservableObject {
    static let shared = LocalState()
    
    var isLandscape: Bool { GlobalState.shared.isLandscapeExcludingiPad }
    
    @Published
    var isScreenOff = false {
        didSet {
            NotificationCenter.default.post(name: .refreshOnceContent, object: nil)
        }
    }
    
    var dodoFrame: CGRect = .zero
}
