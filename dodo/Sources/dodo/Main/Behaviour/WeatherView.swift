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
                Toggle(Copy.enabled, isOn: $preferenceStorage.showWeather)
            } footer: {
                Text(Copy.weatherFooter)
            }
            
            sections
                .disabled(!preferenceStorage.showWeather)
        }
        .navigationTitle(Copy.weather)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                AlertRespringButton()
            }
        }
    }
    
    @ViewBuilder
    private var sections: some View {
        Section {
            Toggle(Copy.autoRefresh, isOn: $preferenceStorage.isActiveWeatherAutomaticRefresh)
            HexColorPicker(selectedColorHex: $preferenceStorage.weatherColor, title: Copy.color)
        } header: {
            Text(Copy.options)
        }
        
        Section {
            Picker(Copy.tapAction, selection: $preferenceStorage.weatherTapAction) {
                ForEach(TapAction.allCases, id: \.rawValue) {
                    Text($0.title)
                        .tag($0.rawValue)
                }
            }
        } header: {
            Text(Copy.tapAction)
        }
        
        Section {
            Toggle(Copy.showHighLow, isOn: $preferenceStorage.isVisibleHighLow)
            Toggle(Copy.showSunriseSunset, isOn: $preferenceStorage.isVisibleSunriseSunset)
        } header: {
            Text(Copy.misc)
        }
    }
}

struct WeatherView_Previews: PreviewProvider {
    static var previews: some View {
        WeatherView()
    }
}
