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
        .navigationTitle(Copy.appearance)
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
            Picker(Copy.timeAndMediaStyle, selection: $preferenceStorage.timeMediaPlayerStyle) {
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
                            title: Copy.modular
                        ),
                        .init(
                            imagePath: "/Library/PreferenceBundles/dodo.bundle/classic.png".rootify,
                            title: Copy.classic
                        )
                    ]
                )
                Toggle(isOn: $preferenceStorage.showDivider) {
                    SubtitleText(
                        title: Copy.showDivider,
                        subtitle: Copy.showDividerDesc
                    )
                }
                Toggle(isOn: $preferenceStorage.showSuggestions) {
                    SubtitleText(
                        title: Copy.showSuggestions,
                        subtitle: Copy.showSuggestionsDesc
                    )
                }
                Toggle(isOn: $preferenceStorage.isMarqueeLabels) {
                    SubtitleText(
                        title: Copy.marqueeLabels,
                        subtitle: Copy.marqueeLabelsDesc
                    )
                }
            }
        } header: {
            Text(Copy.timeAndMediaPlayer)
        } footer: {
            VStack(alignment: .leading, spacing: 20.0) {
                Text(Copy.chooseOverallAppearance)
                Text(
                    """
                    - \(Copy.time): \(Copy.onlyShowTime).
                    - \(Copy.mediaPlayer): \(Copy.onlyShowMediaPlayer).
                    - \(Copy.bothTimeAndMediaPlayer): \(Copy.showTimeAndMediaPlayer).
                    """
                )
            }
        }
    }
    
    var colorsSection: some View {
        Section {
            if TimeMediaPlayerStyle(rawValue: preferenceStorage.timeMediaPlayerStyle) != .mediaPlayer {
                HexColorPicker(selectedColorHex: $preferenceStorage.timeColor, title: Copy.timeColor)
                HexColorPicker(selectedColorHex: $preferenceStorage.dateColor, title: Copy.dateColor)
            }
            if TimeMediaPlayerStyle(rawValue: preferenceStorage.timeMediaPlayerStyle) != .time && preferenceStorage.showDivider {
                HexColorPicker(selectedColorHex: $preferenceStorage.dividerColor, title: Copy.dividerColor)
            }
        } header: {
            Text(Copy.colors)
        }
    }
    
    var playerButtonThemeSection: some View {
        Section {
            NavigationLink(Copy.playerButtonTheme) {
                ThemePickerView()
                    .environmentObject(preferenceStorage)
            }
        } header: {
            Text(Copy.theming)
        } footer: {
            Text(Copy.themingDesc)
        }
    }
    
    var fontSection: some View {
        Section {
            Picker(Copy.font, selection: $preferenceStorage.selectedFont) {
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
                        title: Copy.timeFontSize,
                        subtitle: "\(preferenceStorage.timeFontSize)"
                    )
                }
                Stepper(
                    value: $preferenceStorage.dateFontSize,
                    in: 1...100
                ) {
                    SubtitleText(
                        title: Copy.dateFontSize,
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
                        title: Copy.weatherFontSize,
                        subtitle: "\(preferenceStorage.weatherFontSize)"
                    )
                }
            }
        } header: {
            Text(Copy.fonts)
        } footer: {
            Text(Copy.fontsFooter)
        }
    }
}

struct AppearanceView_Previews: PreviewProvider {
    static var previews: some View {
        AppearanceView()
    }
}
