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
        Button {
            viewModel.updateWeather()
            HapticManager.playHaptic(withIntensity: .success)
        } label: {
            weatherInfo
        }
    }
}

//MARK: - Private

private extension WeatherView {
    var weatherInfo: some View {
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
