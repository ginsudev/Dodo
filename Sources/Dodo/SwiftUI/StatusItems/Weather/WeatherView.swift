//
//  WeatherView.swift
//  
//
//  Created by Noah Little on 22/11/2022.
//

import SwiftUI
import DodoC

//MARK: - Public

struct WeatherView: View {
    @StateObject private var viewModel = ViewModel.shared
    
    var body: some View {
        Button { } label: {
            weatherInfo
                .onTapGesture {
                    viewModel.updateWeather()
                    HapticManager.playHaptic(withIntensity: .success)
                }
                .onLongPressGesture {
                    viewModel.openWeatherApp()
                }
        }
    }
}

//MARK: - Private

private extension WeatherView {
    var weatherInfo: some View {
        HStack {
            Image(uiImage: viewModel.conditionImage)
                .resizable()
                .renderingMode(.original)
                .statusItem()
            Text("\(viewModel.locationName) | \(viewModel.temperature)")
                .font(
                    .system(
                        size: PreferenceManager.shared.settings.weatherFontSize,
                        weight: .regular,
                        design: PreferenceManager.shared.settings.fontType
                    )
                )
                .lineLimit(1)
                .foregroundColor(Color(Colors.weatherColor))
        }
    }
}
