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
    @Environment(\.isLandscape) var isLandscape
    @EnvironmentObject var appsManager: AppsManager
    @StateObject private var viewModel = ViewModel()
    @StateObject private var alarmDataSource = AlarmTimerDataSource.shared
    
    // TODO: - Merge this into the ViewModel and Combine-ify them.
    @StateObject private var dndViewModel = DNDViewModel.shared
    
    var body: some View {
        HStack(spacing: Padding.medium) {
            ForEach(viewModel.statusItems) {
                createStatusItem(type: $0)
            }
            Spacer()
        }
        .frame(
            maxWidth: .infinity,
            idealHeight: viewModel.settings.statusItemSize.height
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
    func textStatusItem(
        _ item: Settings.StatusItem,
        string: String,
        isEnabled: Bool = true,
        onTapAction: (() -> Void)? = nil,
        onLongHoldAction: (() -> Void)? = nil
    ) -> some View {
        let enabledColor = item.enabledColor ?? .white
        let disabledColor = item.disabledColor ?? .white
        let isStatusEnabled = item.isVisible(isStatusEnabled: isEnabled)
        
        StatusItemView(
            isEnabled: isStatusEnabled,
            style: .text(string),
            tint: isEnabled ? enabledColor : disabledColor,
            onTapAction: onTapAction,
            onLongHoldAction: onLongHoldAction
        )
    }
    
    @ViewBuilder
    func imageStatusItem(
        _ item: Settings.StatusItem,
        isEnabled: Bool = true,
        onTapAction: (() -> Void)? = nil,
        onLongHoldAction: (() -> Void)? = nil
    ) -> some View {
        let imageName: String? = {
            if let enabledImage = item.enabledImageName,
               let disabledImage = item.disabledImageName {
                return isEnabled ? enabledImage : disabledImage
            } else {
                switch item {
                case .chargingIcon: return viewModel.chargingImageName
                default: return nil
                }
            }
        }()
        
        let enabledColor = item.enabledColor ?? .white
        let disabledColor = item.disabledColor ?? .white
        let isStatusEnabled = item.isVisible(isStatusEnabled: isEnabled)

        if let imageName {
            StatusItemView(
                isEnabled: isStatusEnabled,
                style: .image(imageName),
                tint: isEnabled ? enabledColor : disabledColor,
                onTapAction: onTapAction,
                onLongHoldAction: onLongHoldAction
            )
        }
    }
    
    @ViewBuilder
    func expandingStatusItem(
        _ item: Settings.StatusItem,
        isEnabled: Bool = true,
        string: String?,
        onTapAction: (() -> Void)? = nil,
        onLongHoldAction: (() -> Void)? = nil
    ) -> some View {
        let imageName: String? = {
            if let enabledImage = item.enabledImageName,
               let disabledImage = item.disabledImageName {
                return isEnabled ? enabledImage : disabledImage
            } else {
                switch item {
                case .chargingIcon: return viewModel.chargingImageName
                default: return nil
                }
            }
        }()
        
        let enabledColor: UIColor = {
            switch item {
            case .chargingIcon: return viewModel.chargingIndicationColor
            default: return item.enabledColor ?? .white
            }
        }()
        let disabledColor = item.disabledColor ?? .white
        let isStatusEnabled = item.isVisible(isStatusEnabled: isEnabled)

        if let imageName, let string {
            StatusItemView(
                isEnabled: isStatusEnabled,
                isEnabledExpansion: isEnabled && !isLandscape,
                style: .expanding(text: string, image: imageName),
                tint: isEnabled ? enabledColor : disabledColor,
                onTapAction: onTapAction,
                onLongHoldAction: onLongHoldAction
            )
        }
    }
    
    @ViewBuilder
    func createStatusItem(type: Settings.StatusItem) -> some View {
        switch type {
        case .lockIcon:
            imageStatusItem(.lockIcon, isEnabled: viewModel.isLocked)
                .onReceive(NotificationCenter.default.publisher(for: .didChangeLockState)) { [weak viewModel] notification in
                    viewModel?.didChangeLockStatus(notification: notification)
                }
        case .chargingIcon:
            expandingStatusItem(.chargingIcon, isEnabled: viewModel.isCharging, string: viewModel.batteryPercentage)
                .onReceive(NotificationCenter.default.publisher(for: UIDevice.batteryStateDidChangeNotification).prepend(.prepended)) { [weak viewModel] _ in
                    viewModel?.updateChargingStatus()
                }
                .onReceive(NotificationCenter.default.publisher(for: UIDevice.batteryLevelDidChangeNotification).prepend(.prepended)) { [weak viewModel] _ in
                    viewModel?.updateChargingVisuals()
                }
        case .alarms:
            expandingStatusItem(
                .alarms,
                isEnabled: alarmDataSource.nextEnabledAlarm != nil,
                string: DateTemplate.time.dateString(date: alarmDataSource.nextEnabledAlarm?.nextFireDate),
                onLongHoldAction: { [weak appsManager] in
                    appsManager?.open(app: .defined(.clock))
                    HapticManager.playHaptic(withIntensity: .custom(.medium))
                }
            )
            .onReceive(NotificationCenter.default.publisher(for: .refreshOnceContent).prepend(.prepended)) { [weak alarmDataSource] _ in
                alarmDataSource?.updateAlarms()
            }
        case .dnd:
            imageStatusItem(.dnd, isEnabled: dndViewModel.isEnabled)
        case .vibration:
            imageStatusItem(.vibration, isEnabled: viewModel.isEnabledVibration)
                .onReceive(NotificationCenter.default.publisher(for: .didChangeRingVibrate).prepend(.prepended)) { [weak viewModel] _ in
                    viewModel?.updateVibrationState()
                }
                .onReceive(NotificationCenter.default.publisher(for: .didChangeSilentVibrate).prepend(.prepended)) { [weak viewModel] _ in
                    viewModel?.updateVibrationState()
                }
        case .muted:
            imageStatusItem(.muted, isEnabled: viewModel.isEnabledMute)
                .onReceive(NotificationCenter.default.publisher(for: .didChangeRinger)) { [weak viewModel] notification in
                    viewModel?.didChangeRingerState(notification: notification)
                }
        case .flashlight:
            HStack {
                Divider()
                    .overlay(Color.white)
                imageStatusItem(.flashlight, isEnabled: viewModel.isActiveFlashlight, onTapAction: { [weak viewModel] in
                    viewModel?.isActiveFlashlight.toggle()
                })
            }
        case .seconds:
            textStatusItem(.seconds, string: viewModel.secondsString)
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
