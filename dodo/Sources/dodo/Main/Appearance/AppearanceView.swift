//
//  AppearanceView.swift
//  
//
//  Created by Noah Little on 7/4/2023.
//

import SwiftUI
import Comet
import GSCore

struct AppearanceView: View {
    @EnvironmentObject var preferenceStorage: PreferenceStorage

    var body: some View {
        Form {
            timeMediaSection
            colorsSection
            playerButtonThemeSection
            fontSection
        }
        .navigationTitle("Appearance")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                AlertRespringButton()
            }
        }
    }
}

private extension AppearanceView {
    var timeMediaSection: some View {
        Section {
            Picker("Time & media style", selection: $preferenceStorage.timeMediaPlayerStyle) {
                ForEach(TimeMediaPlayerStyle.allCases, id: \.rawValue) {
                    Text($0.title)
                        .tag($0.rawValue)
                }
            }
            .pickerStyle(.segmented)
            
            if TimeMediaPlayerStyle(rawValue: preferenceStorage.timeMediaPlayerStyle) != .time {
                SegmentedImagePicker(
                    selection: $preferenceStorage.playerStyle,
                    viewModels: [
                        .init(
                            imagePath: "/Library/PreferenceBundles/dodo.bundle/modular.png".rootify,
                            title: "Modular"
                        ),
                        .init(
                            imagePath: "/Library/PreferenceBundles/dodo.bundle/classic.png".rootify,
                            title: "Classic"
                        )
                    ]
                )
                Toggle(isOn: $preferenceStorage.showDivider) {
                    SubtitleText(
                        title: "Show divider",
                        subtitle: "Show bar between time and media player"
                    )
                }
                Toggle(isOn: $preferenceStorage.showSuggestions) {
                    SubtitleText(
                        title: "Show suggestions",
                        subtitle: "Suggest media apps based on recent listening"
                    )
                }
                Toggle(isOn: $preferenceStorage.isMarqueeLabels) {
                    SubtitleText(
                        title: "Marquee labels",
                        subtitle: "Scrolls text if long enough"
                    )
                }
            }
        } header: {
            Text("Time and media player")
        } footer: {
            VStack(alignment: .leading, spacing: 20.0) {
                Text("Choose an overall appearance for Dodo")
                Text(
                    """
                    - Time: Only shows Dodo's time.
                    - Media player: Only shows Dodo's media player.
                    - Both: Shows Dodo's time and media player.
                    """
                )
            }
        }
    }
    
    var colorsSection: some View {
        Section {
            if TimeMediaPlayerStyle(rawValue: preferenceStorage.timeMediaPlayerStyle) != .mediaPlayer {
                HexColorPicker(selectedColorHex: $preferenceStorage.timeColor, title: "Time color")
                HexColorPicker(selectedColorHex: $preferenceStorage.dateColor, title: "Date color")
            }
            if TimeMediaPlayerStyle(rawValue: preferenceStorage.timeMediaPlayerStyle) != .time && preferenceStorage.showDivider {
                HexColorPicker(selectedColorHex: $preferenceStorage.dividerColor, title: "Divider color")
            }
        } header: {
            Text("Colors")
        }
    }
    
    var playerButtonThemeSection: some View {
        Section {
            NavigationLink("Player button theme") {
                ThemePickerView()
                    .environmentObject(preferenceStorage)
            }
        } header: {
            Text("Theming")
        } footer: {
            Text("Choose a theme for the previous, play and next buttons.")
        }
    }
    
    var fontSection: some View {
        Section {
            Picker("Font", selection: $preferenceStorage.selectedFont) {
                ForEach(FontType.allCases, id: \.rawValue) {
                    Text($0.title)
                        .tag($0.rawValue)
                }
            }
            .pickerStyle(.wheel)
            if TimeMediaPlayerStyle(rawValue: preferenceStorage.timeMediaPlayerStyle) != .mediaPlayer {
                Stepper(
                    value: $preferenceStorage.timeFontSize,
                    in: 1...100
                ) {
                    SubtitleText(
                        title: "Time font size",
                        subtitle: "\(preferenceStorage.timeFontSize)"
                    )
                }
                Stepper(
                    value: $preferenceStorage.dateFontSize,
                    in: 1...100
                ) {
                    SubtitleText(
                        title: "Date font size",
                        subtitle: "\(preferenceStorage.dateFontSize)"
                    )
                }
            }
            if Ecosystem.jailbreakType == .root {
                Stepper(
                    value: $preferenceStorage.weatherFontSize,
                    in: 1...100
                ) {
                    SubtitleText(
                        title: "Weather font size",
                        subtitle: "\(preferenceStorage.weatherFontSize)"
                    )
                }
            }
        } header: {
            Text("Fonts")
        } footer: {
            Text("Choose a font for Dodo.")
        }
    }
}

struct AppearanceView_Previews: PreviewProvider {
    static var previews: some View {
        AppearanceView()
    }
}
