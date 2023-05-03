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
    @StateObject private var viewModel = ViewModel()
    private let settings = PreferenceManager.shared.settings
    
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
        .onReceive(NotificationCenter.default.publisher(for: .refreshOnceContent)) { [weak viewModel] _ in
            viewModel?.updateWeather()
        }
    }
}

//MARK: - Private

private extension WeatherView {
    @ViewBuilder
    var weatherInfo: some View {
        if let appearance = settings?.appearance {
            HStack {
                Image(uiImage: viewModel.conditionImage)
                    .resizable()
                    .renderingMode(.original)
                    .statusItem()
                Text("\(viewModel.locationName) | \(viewModel.temperature)")
                    .font(
                        .system(
                            size: appearance.weatherFontSize,
                            design: appearance.selectedFont.representedFont
                        )
                    )
                    .lineLimit(1)
                    .foregroundColor(Color(settings.colors.weatherColor))
            }
        }
    }
}
