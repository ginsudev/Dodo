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
    @EnvironmentObject var appsManager: AppsManager
    @StateObject private var chargingViewModel = ChargingIconViewModel()
    @StateObject private var lockIconViewModel = LockIconViewModel()
    @StateObject private var alarmDataSource = AlarmTimerDataSource.shared
    @StateObject private var dndViewModel = DNDViewModel.shared
    @StateObject private var flashlightViewModel = FlashlightViewModel()
    @StateObject private var ringerVibrationViewModel = RingerVibrationViewModel()
    @StateObject private var timeDateViewModel = TimeDateView.ViewModel.shared
    let statusItems = PreferenceManager.shared.settings.statusItems
    
    var body: some View {
        HStack(spacing: Dimensions.Padding.medium) {
            ForEach(statusItems, id: \.self) { item in
                statusItem(forType: item)
                    .scaledToFit()
            }
            // timer
            Spacer()
        }
        .frame(
            maxWidth: .infinity,
            idealHeight: dimensions.statusItemSize.height
        )
        .fixedSize(
            horizontal: false,
            vertical: true
        )
    }
}

// MARK: - Private

private extension StatusItemGroupView {
    @ViewBuilder
    func statusItem(forType type: StatusItemView<AnyView>.StatusItem) -> some View {
        switch type {
        case .lockIcon: lockIcon
        case .chargingIcon: chargingIcon
        case .alarms: alarms
        case .dnd: dnd
        case .vibration: vibration
        case .muted: muted
        case .flashlight: flashlight
        case .seconds: seconds
        }
    }
    
    @ViewBuilder
    var lockIcon: some View {
        StatusItemView(tint: Colors.lockIconColor) {
            Image(systemName: lockIconViewModel.lockImageName)
                .resizable()
                .renderingMode(.template)
        }
    }
    
    @ViewBuilder
    var chargingIcon: some View {
        if chargingViewModel.isCharging {
            StatusItemView(
                text: chargingViewModel.batteryPercentage,
                tint: chargingViewModel.indicationColor
            ) {
                Image(systemName: chargingViewModel.imageName)
                    .resizable()
                    .renderingMode(.template)
            }
        }
    }
    
    @ViewBuilder
    var alarms: some View {
        if let alarm = alarmDataSource.nextEnabledAlarm {
            StatusItemView(
                text: TimeDateView.ViewModel.shared.getDate(
                    fromTemplate: .time,
                    date: alarm.nextFireDate
                ),
                tint: Colors.alarmIconColor) {
                    Image(systemName: "alarm.fill")
                        .resizable()
                        .renderingMode(.template)
                } onLongHoldAction: {
                    appsManager.open(app: .defined(.clock))
                    HapticManager.playHaptic(withIntensity: .custom(.medium))
                }
        }
    }
    
//    @ViewBuilder
//    var timer: some View {
//        if let timer = alarmDataSource.nextTimer {
//            StatusItemView(
//                text: TimeDateView.ViewModel.shared.getDate(
//                    fromTemplate: .timeWithSeconds,
//                    date: timer.remainingTimeDate
//                ),
//                tint: Colors.alarmIconColor) {
//                    Image(systemName: "timer")
//                        .resizable()
//                        .renderingMode(.template)
//                } onLongHoldAction: {
//                    appsManager.open(app: .defined(.clock))
//                    HapticManager.playHaptic(withIntensity: .custom(.medium))
//                }
//        }
//    }
    
    @ViewBuilder
    var dnd: some View {
        if dndViewModel.isEnabled {
            StatusItemView(tint: Colors.dndIconColor) {
                Image(systemName: "moon.fill")
                    .resizable()
                    .renderingMode(.template)
            }
        }
    }
    
    @ViewBuilder
    var vibration: some View {
        if ringerVibrationViewModel.isEnabledVibration {
            StatusItemView(tint: Colors.vibrationIconColor) {
                Image(systemName: ringerVibrationViewModel.vibrationImageName)
                    .resizable()
                    .renderingMode(.template)
            }
        }
    }
    
    @ViewBuilder
    var muted: some View {
        if ringerVibrationViewModel.isEnabledMute {
            StatusItemView(tint: Colors.vibrationIconColor) {
                Image(systemName: ringerVibrationViewModel.mutedImageName)
                    .resizable()
                    .renderingMode(.template)
            }
        }
    }
    
    @ViewBuilder
    var flashlight: some View {
        if AVFlashlight.hasFlashlight() {
            HStack {
                Divider()
                    .overlay(Color.white)
                StatusItemView(
                    tint: Colors.vibrationIconColor,
                    content: {
                        Image(systemName: flashlightViewModel.imageName)
                            .resizable()
                            .renderingMode(.template)
                    },
                    onTapAction: {
                        flashlightViewModel.isActiveFlashlight.toggle()
                    }
                )
            }
        }
    }
    
    @ViewBuilder
    var seconds: some View {
        StatusItemView(tint: Colors.vibrationIconColor) {
            Circle()
                .foregroundColor(Color(Colors.secondsIconColor))
                .statusItem()
                .overlay (
                    Text(timeDateViewModel.seconds)
                        .font(.caption2)
                        .bold()
                        .foregroundColor(Color(Colors.secondsIconColor.suitableForegroundColour()))
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
