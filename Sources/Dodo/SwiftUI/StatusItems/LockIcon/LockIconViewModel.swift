//
//  LockIconViewModel.swift
//  
//
//  Created by Noah Little on 11/12/2022.
//

import SwiftUI
import DodoC
import Orion

@MainActor
final class LockIconViewModel: ObservableObject {
    let darwinManager = DarwinNotificationsManager.sharedInstance()
    
    @Published var lockImageName = "lock.fill"
    
    init() {
        darwinManager?.register(forNotificationName: "com.apple.springboard.DeviceLockStatusChanged", callback: { [weak self] in
            self?.didChangeLockStatus()
        })
    }
    
    lazy var lockStateAggregator: SBLockStateAggregator? = {
        if let lockStateAggregator = SBLockStateAggregator.sharedInstance() {
            return lockStateAggregator
        } else {
            return nil
        }
    }()
    
    private func didChangeLockStatus() {
        if let lockStateAggregator = self.lockStateAggregator {
            let state = lockStateAggregator.lockState()
            switch state {
            case 0, 1:
                self.lockImageName = "lock.open.fill"
            default:
                self.lockImageName = "lock.fill"
            }
        }
    }
}
