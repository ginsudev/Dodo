//
//  StatusItemGroupView.swift
//  
//
//  Created by Noah Little on 28/12/2022.
//

import SwiftUI

// MARK: - Public

struct StatusItemGroupView: View {
    @StateObject private var chargingViewModel = ChargingIconViewModel()
    @StateObject private var lockIconViewModel = LockIconViewModel.shared
    @StateObject private var alarmDataSource = AlarmDataSource.shared
    
    var body: some View {
        HStack(spacing: 10.0) {
            lockIcon
            chargingIcon
            alarms
        }
        .frame(maxHeight: 18)
        .onAppear {
        }
    }
}

// MARK: - Private

private extension StatusItemGroupView {
    @ViewBuilder
    var lockIcon: some View {
        if PreferenceManager.shared.settings.hasLockIcon {
            StatusImage(
                image: Image(systemName: lockIconViewModel.lockImageName),
                color: Color(Colors.lockIconColor)
            )
        }
    }
    
    @ViewBuilder
    var chargingIcon: some View {
        if PreferenceManager.shared.settings.hasChargingIcon,
           chargingViewModel.isCharging {
            StatusImage(
                image: Image(systemName: chargingViewModel.imageName),
                color: chargingViewModel.indicationColor
            )
        }
    }
    
    @ViewBuilder
    var alarms: some View {
        if let alarm = alarmDataSource.nextEnabledAlarm {
            AlarmView(alarm: alarm)
        }
    }
}

// MARK: - Previews

struct StatusItemGroupView_Previews: PreviewProvider {
    static var previews: some View {
        StatusItemGroupView()
    }
}
