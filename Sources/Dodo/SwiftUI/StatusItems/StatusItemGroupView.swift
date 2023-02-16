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
    let statusItems = PreferenceManager.shared.settings.statusItems
    
    var body: some View {
        HStack(spacing: Dimensions.Padding.medium) {
            ForEach(statusItems, id: \.self) { item in
                statusItem(forType: item)
            }
        }
        .frame(maxHeight: dimensions.statusItemSize.height)
    }
}

// MARK: - Private

private extension StatusItemGroupView {
    @ViewBuilder
    func statusItem(forType type: StatusItemView.StatusItem) -> some View {
        switch type {
        case .lockIcon: lockIcon
        case .chargingIcon: chargingIcon
        case .alarms: alarms
        case .dnd: dnd
        case .vibration: vibration
        case .muted: muted
        case .flashlight: flashlight
        }
    }
    
    @ViewBuilder
    var lockIcon: some View {
        StatusItemView(
            image: Image(systemName: lockIconViewModel.lockImageName),
            tint: Colors.lockIconColor
        )
    }
    
    @ViewBuilder
    var chargingIcon: some View {
        if chargingViewModel.isCharging {
            StatusItemView(
                image: Image(systemName: chargingViewModel.imageName),
                tint: chargingViewModel.indicationColor,
                text: chargingViewModel.batteryPercentage
            )
        }
    }
    
    @ViewBuilder
    var alarms: some View {
        if let alarm = alarmDataSource.nextEnabledAlarm {
            AlarmView(alarm: alarm)
        }
    }
    
    @ViewBuilder
    var dnd: some View {
        if dndViewModel.isEnabled {
            StatusItemView(
                image: Image(systemName: "moon.fill"),
                tint: Colors.dndIconColor
            )
        }
    }
    
    @ViewBuilder
    var vibration: some View {
        if ringerVibrationViewModel.isEnabledVibration {
            StatusItemView(
                image: Image(systemName: ringerVibrationViewModel.vibrationImageName),
                tint: Colors.vibrationIconColor
            )
        }
    }
    
    @ViewBuilder
    var muted: some View {
        if ringerVibrationViewModel.isEnabledMute {
            StatusItemView(
                image: Image(systemName: ringerVibrationViewModel.mutedImageName),
                tint: Colors.mutedIconColor
            )
        }
    }
    
    @ViewBuilder
    var flashlight: some View {
        if AVFlashlight.hasFlashlight() {
            HStack {
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
    
//    var rows: [GridItem] {
//        return Array(repeating: .init(.flexible(minimum: dimensions.statusItemSize.height), spacing: 10.0, alignment: .leading), count: dimensions.isLandscape ? 2 : 1)
//    }
}

// MARK: - Previews

struct StatusItemGroupView_Previews: PreviewProvider {
    static var previews: some View {
        StatusItemGroupView()
    }
}
