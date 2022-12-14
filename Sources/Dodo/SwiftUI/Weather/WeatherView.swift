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
            viewModel.updateWeather(forced: true)
            HapticManager.playHaptic(withIntensity: .success)
        } label: {
            weatherInfo
        }
    }
}

//MARK: - Private

private extension WeatherView {
    var weatherInfo: some View {
        HStack(alignment: .center, spacing: 0) {
            Image(uiImage: viewModel.conditionImage)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 35, height: 35)
            Text("\(viewModel.locationName) | \(viewModel.temperature)")
                .font(.system(size: 15, weight: .regular, design: PreferenceManager.shared.settings.fontType))
                .lineLimit(1)
                .foregroundColor(Color(Colors.weatherColor))
        }
    }
}
