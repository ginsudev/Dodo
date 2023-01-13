//
//  LockIconViewModel.swift
//  
//
//  Created by Noah Little on 11/12/2022.
//

import SwiftUI
import DodoC
import Orion

final class LockIconViewModel: ObservableObject {
    @Published var lockImageName = "lock.fill"
    
    init() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(didChangeLockStatus(notification:)),
            name: NSNotification.Name(Notifications.nc_lockStateDidChange),
            object: nil
        )
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc private func didChangeLockStatus(notification: Notification) {
        if let info = notification.userInfo,
           let state = info["SBAggregateLockStateKey"] as? Int {
            switch state {
            case 0, 1:
                self.lockImageName = "lock.open.fill"
            default:
                self.lockImageName = "lock.fill"
            }
        }
    }
}
