//
//  LockIcon.ViewModel.swift
//  
//
//  Created by Noah Little on 11/12/2022.
//

import SwiftUI

extension LockIcon {
    final class ViewModel: ObservableObject {
        static let shared = ViewModel()
        @Published var lockImageName = "lock.fill"
    }
}
