//
//  WeatherView.swift
//  
//
//  Created by Noah Little on 22/4/2023.
//

import SwiftUI
import Comet
import GSCore

struct WeatherView: View {
    @EnvironmentObject var preferenceStorage: PreferenceStorage
    
    var body: some View {
        Form {
            if Ecosystem.jailbreakType == .rootless {
                Section {
                    Text("This feature is unavailable for rootless jailbreaks at the moment.")
                        .foregroundColor(.red)
                }
            }
            
            Section {
                Toggle("Enabled", isOn: $preferenceStorage.showWeather)
            } footer: {
                Text("Display the weather above Dodo's clock. Long hold the weather to refresh.")
            }

            Section {
                Toggle("Auto refresh", isOn: $preferenceStorage.isActiveWeatherAutomaticRefresh)
                HexColorPicker(selectedColorHex: $preferenceStorage.weatherColor, title: "Color")
            } header: {
                Text("Options")
            }
            .disabled(!preferenceStorage.showWeather)
        }
        .disabled(Ecosystem.jailbreakType == .rootless)
        .navigationTitle("Weather")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                AlertRespringButton()
            }
        }
    }
}

struct WeatherView_Previews: PreviewProvider {
    static var previews: some View {
        WeatherView()
    }
}
