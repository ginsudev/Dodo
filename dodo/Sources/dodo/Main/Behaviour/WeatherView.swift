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
