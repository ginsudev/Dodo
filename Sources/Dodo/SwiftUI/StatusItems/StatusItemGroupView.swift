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
    @StateObject private var viewModel = ViewModel()
    
    // TODO: - Merge these into the ViewModel and Combine-ify them.
    @StateObject private var alarmDataSource = AlarmTimerDataSource.shared
    @StateObject private var dndViewModel = DNDViewModel.shared
    @StateObject private var flashlightViewModel = FlashlightViewModel()
    
    var body: some View {
        HStack(spacing: Dimensions.Padding.medium) {
            ForEach(viewModel.statusItems) {
                createStatusItem(type: $0)
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
    var lockIcon: some View {
        StatusItemView(tint: Colors.lockIconColor) {
            Image(systemName: viewModel.lockImageName)
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
                } onLongHoldAction: {
                    appsManager.open(app: .defined(.clock))
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
}

// MARK: - Previews

struct StatusItemGroupView_Previews: PreviewProvider {
    static var previews: some View {
        StatusItemGroupView()
    }
}
