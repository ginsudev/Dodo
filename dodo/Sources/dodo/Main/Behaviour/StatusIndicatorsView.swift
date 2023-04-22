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
                Toggle("Enabled", isOn: $preferenceStorage.hasStatusItems)
            } footer: {
                Text("Display indicators for various system components above Dodo's clock.")
            }
            
            Section {
                Stepper(value: $preferenceStorage.indicatorSize, in: 13.0...30.0) {
                    SubtitleText(
                        title: "Indicator size",
                        subtitle: "\(preferenceStorage.indicatorSize)"
                    )
                }
            } header: {
                Text("Size")
            }
            .disabled(!preferenceStorage.hasStatusItems)
            
            indicatorsSection
                .disabled(!preferenceStorage.hasStatusItems)
        }
        .navigationTitle("Status indicators")
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
                Toggle("\(option.name) indicator", isOn: option.isEnabled)
                if let color = option.color, option.isEnabled.wrappedValue {
                    HexColorPicker(selectedColorHex: color, title: "Color")
                }
            } header: {
                Text(option.name)
            }
        }
    }
    
    var inidicatorOptions: [(isEnabled: Binding<Bool>, color: Binding<String>?, name: String)] {
        [
            ($preferenceStorage.hasLockIcon, $preferenceStorage.lockIconColor, "Lock"),
            ($preferenceStorage.hasChargingIcon, nil, "Charging"),
            ($preferenceStorage.hasAlarmIcon, $preferenceStorage.alarmIconColor, "Alarm"),
            ($preferenceStorage.hasDNDIcon, $preferenceStorage.dndIconColor, "DND"),
            ($preferenceStorage.hasFlashlightIcon, $preferenceStorage.flashlightIconColor, "Flashlight"),
            ($preferenceStorage.hasVibrationIcon, $preferenceStorage.vibrationIconColor, "Vibration"),
            ($preferenceStorage.hasMutedIcon, $preferenceStorage.mutedIconColor, "Muted"),
            ($preferenceStorage.hasSecondsIcon, $preferenceStorage.secondsIconColor, "Seconds"),
        ]
    }
}

struct StatusIndicatorsView_Previews: PreviewProvider {
    static var previews: some View {
        StatusIndicatorsView()
    }
}
