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
        .navigationTitle("Behaviour")
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
                "Time format",
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
                Toggle("24 Hour mode", isOn: $preferenceStorage.isEnabled24HourMode)
            }
        } header: {
            Text("Time formatting")
        }
    }
    
    var dateFormattingSection: some View {
        Section {
            Text(formattedDateString)
                .foregroundColor(.secondary)
            Picker(
                "Date format",
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
            Text("Date formatting")
        }
    }
    
    var favouriteAppsSection: some View {
        Section {
            NavigationLink("Favourite apps") {
                FavouriteAppsView()
                    .environmentObject(preferenceStorage)
            }
        } footer: {
            Text("Choose your favourite apps to display on the lock screen.")
        }
    }
    
    var statusIndicatorsSection: some View {
        Section {
            NavigationLink("Status indicators") {
                StatusIndicatorsView()
                    .environmentObject(preferenceStorage)
            }
        } footer: {
            Text("Add indicators for various system statuses.")
        }
    }
    
    var weatherSection: some View {
        Section {
            NavigationLink("Weather") {
                WeatherView()
                    .environmentObject(preferenceStorage)
            }
        } footer: {
            Text("Configure weather options.")
        }
    }
    
    var dimensionsSection: some View {
        Section {
            DetailedSlider(
                value: $preferenceStorage.notificationVerticalOffset,
                range: 0...1000,
                title: "Notification Y offset"
            )
        } header: {
            Text("Dimensions")
        }
    }
    
    var chargingSection: some View {
        Section {
            Toggle(isOn: $preferenceStorage.hasChargingFlash) {
                SubtitleText(
                    title: "Charging flash",
                    subtitle: "Flash screen green while charging"
                )
            }
        } header: {
            Text("Misc")
        }
    }
    
    var formattedDateString: String {
        let format = DateTemplate(rawValue: preferenceStorage.selectedDateTemplate)?.format ?? preferenceStorage.dateTemplateCustomFormat
        return format.isEmpty ? "Preview" :  viewModel.formattedDate(format: format)
    }
    
    var formattedTimeString: String {
        let format = TimeTemplate(rawValue: preferenceStorage.selectedTimeTemplate)?.format ?? preferenceStorage.timeTemplateCustomFormat
        return format.isEmpty ? "Preview" : viewModel.formattedDate(format: format)
    }
}

// MARK: - Previews

struct BehaviourView_Previews: PreviewProvider {
    static var previews: some View {
        BehaviourView()
    }
}
