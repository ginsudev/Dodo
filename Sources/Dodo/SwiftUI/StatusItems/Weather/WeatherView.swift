//
//  WeatherView.swift
//  
//
//  Created by Noah Little on 22/11/2022.
//

import SwiftUI
import DodoC

// MARK: - Internal

struct WeatherView: View {
    @StateObject
    private var viewModel = ViewModel()
    
    private let settings = PreferenceManager.shared.settings

    var body: some View {
        Button { } label: {
            buttonLabelView
        }
        .onReceive(
            condition: settings.weather.isActiveWeatherAutomaticRefresh,
            publisher: NotificationCenter.default.publisher(for: .refreshOnceContent).prepend(.prepended)
        ) { [weak viewModel] _ in
            viewModel?.updateWeather()
        }
    }
}

// MARK: - Private

private extension WeatherView {
    var buttonLabelView: some View {
        VStack(alignment: .leading, spacing: 4.0) {
            weatherTextView
            sunriseSunsetView
        }
        .dodoFont(size: settings.appearance.weatherFontSize)
        .lineLimit(1)
        .foregroundColor(Color(settings.colors.weatherColor))
        .onTapGesture {
            viewModel.onTapWeather()
        }
        .onLongPressGesture {
            viewModel.openWeatherApp()
        }
    }
    
    @ViewBuilder
    var weatherTextView: some View {
        if let weatherString = viewModel.weatherString {
            Text(weatherString)
        }
    }
    
    @ViewBuilder
    var sunriseSunsetView: some View {
        if let sunrise = viewModel.sunriseString,
           let sunset = viewModel.sunsetString {
            HStack(spacing: 4.0) {
                weatherLabel(imageName: "sunrise.fill", text: sunrise)
                weatherLabel(imageName: "sunset.fill", text: sunset)
            }
        }
    }
    
    func weatherLabel(imageName: String, text: String) -> some View {
        HStack(spacing: 2.0) {
            Image(systemName: imageName)
            Text(text)
        }
    }
}
