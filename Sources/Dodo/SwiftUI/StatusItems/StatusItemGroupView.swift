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
    @Environment(\.isVisibleLockScreen) var isVisibleLockScreen
    @EnvironmentObject var dimensions: Dimensions
    @EnvironmentObject var appsManager: AppsManager
    @StateObject private var viewModel = ViewModel()
    @StateObject private var alarmDataSource = AlarmTimerDataSource.shared

    // TODO: - Merge this into the ViewModel and Combine-ify them.
    @StateObject private var dndViewModel = DNDViewModel.shared
    
    var body: some View {
        HStack(spacing: Dimensions.Padding.medium) {
            ForEach(viewModel.statusItems) {
                createStatusItem(type: $0)
            }
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
    var lockIcon: some View {
        StatusItemView(tint: Colors.lockIconColor) {
            Image(systemName: viewModel.isLocked ? "lock.fill" : "lock.open.fill")
                .resizable()
                .renderingMode(.template)
        }
    }
    
    @ViewBuilder
    var chargingIcon: some View {
        if viewModel.isCharging {
            StatusItemView(
                text: viewModel.batteryPercentage,
                tint: viewModel.chargingIndicationColor
            ) {
                Image(systemName: viewModel.chargingImageName)
                    .resizable()
                    .renderingMode(.template)
            }
        }
    }
    
    @ViewBuilder
    var alarms: some View {
        if let alarm = alarmDataSource.nextEnabledAlarm {
            StatusItemView(
                text: DateTemplate.time.dateString(date: alarm.nextFireDate),
                tint: Colors.alarmIconColor) {
                    Image(systemName: "alarm.fill")
                        .resizable()
                        .renderingMode(.template)
                } onLongHoldAction: { [weak appsManager] in
                    appsManager?.open(app: .defined(.clock))
                    HapticManager.playHaptic(withIntensity: .custom(.medium))
                }
        }
    }
    
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
        let vibrationImageName: String = {
            if #available(iOS 15, *) {
                return "iphone.radiowaves.left.and.right.circle.fill"
            } else {
                return "waveform.circle.fill"
            }
        }()
        
        if viewModel.isEnabledVibration {
            StatusItemView(tint: Colors.vibrationIconColor) {
                Image(systemName: vibrationImageName)
                    .resizable()
                    .renderingMode(.template)
            }
        }
    }
    
    @ViewBuilder
    var muted: some View {
        if viewModel.isEnabledMute {
            StatusItemView(tint: Colors.mutedIconColor) {
                Image(systemName: "bell.slash.fill")
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
                    tint: Colors.flashlightIconColor,
                    content: {
                        Image(systemName: viewModel.isActiveFlashlight ? "flashlight.on.fill" : "flashlight.off.fill")
                            .resizable()
                            .renderingMode(.template)
                    },
                    onTapAction: { [weak viewModel] in
                        viewModel?.isActiveFlashlight.toggle()
                    }
                )
            }
        }
    }
    
    @ViewBuilder
    var seconds: some View {
        StatusItemView(tint: Colors.vibrationIconColor) {
            Text(viewModel.secondsString)
                .font(.caption2)
                .bold()
                .foregroundColor(Color(Colors.secondsIconColor.suitableForegroundColour()))
                .background(
                    Circle()
                        .foregroundColor(Color(Colors.secondsIconColor))
                        .statusItem()
                )
        }
    }
    
    @ViewBuilder
    func createStatusItem(type: Settings.StatusItem) -> some View {
        switch type {
        case .lockIcon:
            lockIcon
                .onReceive(NotificationCenter.default.publisher(for: .didChangeLockState)) { [weak viewModel] notification in
                    viewModel?.didChangeLockStatus(notification: notification)
                }
        case .chargingIcon:
            chargingIcon
                .onReceive(NotificationCenter.default.publisher(for: UIDevice.batteryStateDidChangeNotification).prepend(.prepended)) { [weak viewModel] _ in
                    viewModel?.updateChargingStatus()
                }
                .onReceive(NotificationCenter.default.publisher(for: UIDevice.batteryLevelDidChangeNotification).prepend(.prepended)) { [weak viewModel] _ in
                    viewModel?.updateChargingVisuals()
                }
        case .alarms:
            alarms
                .onReceive(NotificationCenter.default.publisher(for: .refreshOnceContent).prepend(.prepended)) { [weak alarmDataSource] _ in
                    alarmDataSource?.updateAlarms()
                }
        case .dnd:
            dnd
        case .vibration:
            vibration
                .onReceive(NotificationCenter.default.publisher(for: .didChangeRingVibrate).prepend(.prepended)) { [weak viewModel] _ in
                    viewModel?.updateVibrationState()
                }
                .onReceive(NotificationCenter.default.publisher(for: .didChangeSilentVibrate).prepend(.prepended)) { [weak viewModel] _ in
                    viewModel?.updateVibrationState()
                }
        case .muted:
            muted
                .onReceive(NotificationCenter.default.publisher(for: .didChangeRinger)) { [weak viewModel] notification in
                    viewModel?.didChangeRingerState(notification: notification)
                }
        case .flashlight:
            flashlight
        case .seconds:
            seconds
                .onReceive(NotificationCenter.default.publisher(for: .refreshContent).prepend(.prepended)) { [weak viewModel] _ in
                    viewModel?.updateSeconds()
                }
        }
    }
}

// MARK: - Previews

struct StatusItemGroupView_Previews: PreviewProvider {
    static var previews: some View {
        StatusItemGroupView()
    }
}
