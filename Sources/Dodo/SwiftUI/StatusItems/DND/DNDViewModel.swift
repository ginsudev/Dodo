//
//  DNDViewModel.swift
//  
//
//  Created by Noah Little on 8/1/2023.
//

import Foundation

final class DNDViewModel: ObservableObject {
    static let shared = DNDViewModel()
    
    @Published var isEnabled = PreferenceManager.shared.defaults.bool(forKey: Keys.isEnabledDND) {
        didSet {
            PreferenceManager.shared.defaults.set(isEnabled, forKey: Keys.isEnabledDND)
        }
    }
}
