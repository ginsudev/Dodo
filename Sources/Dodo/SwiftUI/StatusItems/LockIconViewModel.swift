//
//  LockIconViewModel.swift
//  
//
//  Created by Noah Little on 11/12/2022.
//

import SwiftUI

final class LockIconViewModel: ObservableObject {
    static let shared = LockIconViewModel()
    @Published var lockImageName = "lock.fill"
}
