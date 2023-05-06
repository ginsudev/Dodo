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
                    Text(Copy.unavailableRootless)
                        .foregroundColor(.red)
                }
            }
            
            Section {
                Toggle(Copy.enabled, isOn: $preferenceStorage.showWeather)
            } footer: {
                Text(Copy.weatherFooter)
            }

            Section {
                Toggle(Copy.autoRefresh, isOn: $preferenceStorage.isActiveWeatherAutomaticRefresh)
                HexColorPicker(selectedColorHex: $preferenceStorage.weatherColor, title: Copy.color)
            } header: {
                Text(Copy.options)
            }
            .disabled(!preferenceStorage.showWeather)
        }
        .disabled(Ecosystem.jailbreakType == .rootless)
        .navigationTitle(Copy.weather)
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
