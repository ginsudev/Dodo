//
//  StatusItemGroupView.swift
//  
//
//  Created by Noah Little on 28/12/2022.
//

import SwiftUI
import DodoC

// MARK: - Public

struct StatusItemGroupView: View {
    @EnvironmentObject var dimensions: Dimensions
    @StateObject private var chargingViewModel = ChargingIconViewModel()
    @StateObject private var lockIconViewModel = LockIconViewModel()
    @StateObject private var alarmDataSource = AlarmDataSource.shared
    @StateObject private var dndViewModel = DNDViewModel.shared
    @StateObject private var flashlightViewModel = FlashlightViewModel()
    @StateObject private var ringerVibrationViewModel = RingerVibrationViewModel()
    
    var body: some View {
        HStack(spacing: 10.0) {
            // Indication
            lockIcon
            chargingIcon
            alarms
            dnd
            vibration
            muted
            // Action
            flashlight
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
        if PreferenceManager.shared.settings.hasAlarmIcon,
           let alarm = alarmDataSource.nextEnabledAlarm {
            AlarmView(alarm: alarm)
        }
    }
    
    @ViewBuilder
    var dnd: some View {
        if PreferenceManager.shared.settings.hasDNDIcon,
           dndViewModel.isEnabled {
            StatusItemView(
                image: Image(systemName: "moon.fill"),
                tint: Colors.dndIconColor
            )
        }
    }
    
    @ViewBuilder
    var vibration: some View {
        if PreferenceManager.shared.settings.hasVibrationIcon,
           ringerVibrationViewModel.isEnabledVibration {
            StatusItemView(
                image: Image(systemName: ringerVibrationViewModel.vibrationImageName),
                tint: Colors.vibrationIconColor
            )
        }
    }
    
    @ViewBuilder
    var muted: some View {
        if PreferenceManager.shared.settings.hasMutedIcon,
           ringerVibrationViewModel.isEnabledMute {
            StatusItemView(
                image: Image(systemName: ringerVibrationViewModel.mutedImageName),
                tint: Colors.mutedIconColor
            )
        }
    }
    
    @ViewBuilder
    var flashlight: some View {
        if PreferenceManager.shared.settings.hasFlashlightIcon,
           AVFlashlight.hasFlashlight() {
            Divider()
                .overlay(Color.white)
            StatusItemView(
                image: Image(systemName: flashlightViewModel.imageName),
                tint: Colors.flashlightIconColor, onTapAction: {
                    flashlightViewModel.isActiveFlashlight.toggle()
                }
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
