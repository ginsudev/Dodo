//
//  BehaviourView.swift
//  
//
//  Created by Noah Little on 4/4/2023.
//

import SwiftUI
import GSCore
import Comet

// MARK: - Public

struct BehaviourView: View {
    @EnvironmentObject var preferenceStorage: PreferenceStorage
    private let viewModel = ViewModel()
    
    var body: some View {
        Form {
            timeFormattingSection
            dateFormattingSection
            favouriteAppsSection
            statusIndicatorsSection
            weatherSection
            dimensionsSection
            chargingSection
        }
        .navigationTitle(Copy.behaviour)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                AlertRespringButton()
            }
        }
    }
}

// MARK: - Private

private extension BehaviourView {
    var timeFormattingSection: some View {
        Section {
            Text(formattedTimeString)
                .foregroundColor(.secondary)
            Picker(
                Copy.timeFormat,
                selection: $preferenceStorage.selectedTimeTemplate.animation()) {
                    ForEach(TimeTemplate.allCases, id: \.rawValue) {
                        Text($0.title)
                            .tag($0.rawValue)
                    }
                }
                .pickerStyle(.segmented)
            if TimeTemplate(rawValue: preferenceStorage.selectedTimeTemplate) == .custom {
                TextField("h:mm", text: $preferenceStorage.timeTemplateCustomFormat)
            } else {
                Toggle(Copy.twentyFourHourMode, isOn: $preferenceStorage.isEnabled24HourMode)
            }
        } header: {
            Text(Copy.timeFormatting)
        }
    }
    
    var dateFormattingSection: some View {
        Section {
            Text(formattedDateString)
                .foregroundColor(.secondary)
            Picker(
                Copy.dateFormat,
                selection: $preferenceStorage.selectedDateTemplate.animation()) {
                    ForEach(DateTemplate.allCases, id: \.rawValue) {
                        Text($0.title)
                            .tag($0.rawValue)
                    }
                }
                .pickerStyle(.segmented)
            if DateTemplate(rawValue: preferenceStorage.selectedDateTemplate) == .custom {
                TextField("EEEE, MMMM d", text: $preferenceStorage.dateTemplateCustomFormat)
            }
        } header: {
            Text(Copy.dateFormatting)
        }
    }
    
    var favouriteAppsSection: some View {
        Section {
            NavigationLink(Copy.favouriteApps) {
                FavouriteAppsView()
                    .environmentObject(preferenceStorage)
            }
        } footer: {
            Text(Copy.favouriteAppsDesc)
        }
    }
    
    var statusIndicatorsSection: some View {
        Section {
            NavigationLink(Copy.statusIndicators) {
                StatusIndicatorsView()
                    .environmentObject(preferenceStorage)
            }
        } footer: {
            Text(Copy.statusIndicatorsDesc)
        }
    }
    
    var weatherSection: some View {
        Section {
            NavigationLink(Copy.weather) {
                WeatherView()
                    .environmentObject(preferenceStorage)
            }
        } footer: {
            Text(Copy.weatherDesc)
        }
    }
    
    var dimensionsSection: some View {
        Section {
            DetailedSlider(
                value: $preferenceStorage.notificationVerticalOffset,
                range: 0...1000,
                title: Copy.notificationVerticalOffset
            )
        } header: {
            Text(Copy.dimensions)
        }
    }
    
    var chargingSection: some View {
        Section {
            Toggle(isOn: $preferenceStorage.hasChargingFlash) {
                SubtitleText(
                    title: Copy.chargingFlash,
                    subtitle: Copy.chargingFlashDesc
                )
            }
        } header: {
            Text(Copy.misc)
        }
    }
    
    var formattedDateString: String {
        let format = DateTemplate(rawValue: preferenceStorage.selectedDateTemplate)?.format ?? preferenceStorage.dateTemplateCustomFormat
        return format.isEmpty ? Copy.preview :  viewModel.formattedDate(format: format)
    }
    
    var formattedTimeString: String {
        let format = TimeTemplate(rawValue: preferenceStorage.selectedTimeTemplate)?.format ?? preferenceStorage.timeTemplateCustomFormat
        return format.isEmpty ? Copy.preview : viewModel.formattedDate(format: format)
    }
}

// MARK: - Previews

struct BehaviourView_Previews: PreviewProvider {
    static var previews: some View {
        BehaviourView()
    }
}
