//
//  StatusItemGroupView.swift
//  
//
//  Created by Noah Little on 28/12/2022.
//

import SwiftUI

// MARK: - Public

struct StatusItemGroupView: View {
    @EnvironmentObject var dimensions: Dimensions
    @StateObject private var chargingViewModel = ChargingIconViewModel()
    @StateObject private var lockIconViewModel = LockIconViewModel.shared
    @StateObject private var alarmDataSource = AlarmDataSource.shared
    @StateObject private var dndViewModel = DNDViewModel.shared
    
    var body: some View {
        HStack(spacing: 10.0) {
            lockIcon
            chargingIcon
            alarms
            dnd
        }
        .frame(maxHeight: dimensions.statusItemSize.height)
    }
}

// MARK: - Private

private extension StatusItemGroupView {
    @ViewBuilder
    var lockIcon: some View {
        if PreferenceManager.shared.settings.hasLockIcon {
            StatusItemView(
                image: Image(systemName: lockIconViewModel.lockImageName),
                tint: Colors.lockIconColor
            )
        }
    }
    
    @ViewBuilder
    var chargingIcon: some View {
        if PreferenceManager.shared.settings.hasChargingIcon,
           chargingViewModel.isCharging {
            StatusItemView(
                image: Image(systemName: chargingViewModel.imageName),
                tint: chargingViewModel.indicationColor,
                text: chargingViewModel.batteryPercentage
            )
        }
    }
    
    @ViewBuilder
    var alarms: some View {
        if PreferenceManager.shared.settings.hasAlarmIcon, let alarm = alarmDataSource.nextEnabledAlarm {
            AlarmView(alarm: alarm)
        }
    }
    
    @ViewBuilder
    var dnd: some View {
        if PreferenceManager.shared.settings.hasDNDIcon, dndViewModel.isEnabled {
            StatusItemView(
                image: Image(systemName: "moon.fill"),
                tint: Colors.dndIconColor
            )
        }
    }
}

// MARK: - Previews

struct StatusItemGroupView_Previews: PreviewProvider {
    static var previews: some View {
        StatusItemGroupView()
    }
}
