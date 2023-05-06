//
//  StatusIndicatorsView.swift
//  
//
//  Created by Noah Little on 22/4/2023.
//

import SwiftUI
import Comet
import GSCore

// MARK: - Internal

struct StatusIndicatorsView: View {
    @EnvironmentObject var preferenceStorage: PreferenceStorage
    
    var body: some View {
        Form {
            Section {
                Toggle(Copy.enabled, isOn: $preferenceStorage.hasStatusItems)
            } footer: {
                Text(Copy.displayIndicators)
            }
            
            Section {
                Toggle(isOn: $preferenceStorage.isVisibleWhenDisabled) {
                    SubtitleText(
                        title: Copy.showWhenDisabled,
                        subtitle: Copy.showWhenDisabledDesc
                    )
                }
                Stepper(value: $preferenceStorage.indicatorSize, in: 13.0...30.0) {
                    SubtitleText(
                        title: Copy.indicatorSize,
                        subtitle: "\(preferenceStorage.indicatorSize)"
                    )
                }
            } header: {
                Text(Copy.size)
            }
            .disabled(!preferenceStorage.hasStatusItems)
            
            indicatorsSection
                .disabled(!preferenceStorage.hasStatusItems)
        }
        .navigationTitle(Copy.statusIndicators)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                AlertRespringButton()
            }
        }
    }
}

// MARK: - Private

private extension StatusIndicatorsView {
    var indicatorsSection: some View {
        ForEach(inidicatorOptions, id: \.name) { option in
            Section {
                Toggle(Copy.indicator(option.name), isOn: option.isEnabled)
                if let color = option.color, option.isEnabled.wrappedValue {
                    HexColorPicker(selectedColorHex: color, title: Copy.color)
                }
            } header: {
                Text(option.name)
            }
        }
    }
    
    var inidicatorOptions: [(isEnabled: Binding<Bool>, color: Binding<String>?, name: String)] {
        [
            ($preferenceStorage.hasLockIcon, $preferenceStorage.lockIconColor, Copy.lock),
            ($preferenceStorage.hasChargingIcon, nil, Copy.charging),
            ($preferenceStorage.hasAlarmIcon, $preferenceStorage.alarmIconColor, Copy.alarm),
            ($preferenceStorage.hasDNDIcon, $preferenceStorage.dndIconColor, Copy.dnd),
            ($preferenceStorage.hasFlashlightIcon, $preferenceStorage.flashlightIconColor, Copy.flashlight),
            ($preferenceStorage.hasVibrationIcon, $preferenceStorage.vibrationIconColor, Copy.vibration),
            ($preferenceStorage.hasMutedIcon, $preferenceStorage.mutedIconColor, Copy.muted),
            ($preferenceStorage.hasSecondsIcon, $preferenceStorage.secondsIconColor, Copy.seconds),
        ]
    }
}

struct StatusIndicatorsView_Previews: PreviewProvider {
    static var previews: some View {
        StatusIndicatorsView()
    }
}
