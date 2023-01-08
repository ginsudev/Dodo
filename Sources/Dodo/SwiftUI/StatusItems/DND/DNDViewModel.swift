//
//  DNDViewModel.swift
//  
//
//  Created by Noah Little on 8/1/2023.
//

import Foundation

final class DNDViewModel: ObservableObject {
    static let shared = DNDViewModel()
    @Published var isEnabled = UserDefaults.standard.bool(forKey: "Dodo.isEnabledDND") {
        didSet {
            UserDefaults.standard.set(isEnabled, forKey: "Dodo.isEnabledDND")
        }
    }
}
