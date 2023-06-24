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
    @StateObject
    private var viewModel = ViewModel()
    
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
        .onReceive(
            condition: settings.weather.isActiveWeatherAutomaticRefresh,
            publisher: NotificationCenter.default.publisher(for: .refreshOnceContent).prepend(.prepended)
        ) { [weak viewModel] _ in
            viewModel?.updateWeather()
        }
    }
}

//MARK: - Private

private extension WeatherView {
    var weatherInfo: some View {
        HStack {
            if let imageName = viewModel.conditionImageName {
                Image(imageName)
                    .resizable()
                    .renderingMode(.original)
                    .frame(
                        width: settings.statusItems.statusItemSize.width,
                        height: settings.statusItems.statusItemSize.height
                    )
                    .aspectRatio(contentMode: .fit)
            }
            
            if let displayedString = viewModel.displayedString {
                Text(displayedString)
                    .dodoFont(size: settings.appearance.weatherFontSize)
                    .lineLimit(1)
                    .foregroundColor(Color(settings.colors.weatherColor))
            }
        }
    }
}
