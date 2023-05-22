//
//  MainContent.swift
//  
//
//  Created by Noah Little on 19/11/2022.
//

import SwiftUI

//MARK: - Public

struct MainContent: View {
    @Environment(\.isVisibleLockScreen) var isVisibleLockScreen
    @Environment(\.isLandscape) var isLandscape
    @State private var infoViewFrame: CGRect = .zero
    
    private let settings = PreferenceManager.shared.settings

    var body: some View {
        HStack(
            alignment: .center,
            spacing: 0
        ) {
            infoView
            Spacer()
            favouriteApps
        }
    }
}

private extension MainContent {
    @ViewBuilder
    var infoView: some View {
        VStack(
            alignment: .leading,
            spacing: 0.0
        ) {
            weatherView
            TimeDateView()
        }
        .fixedSize(
            horizontal: true,
            vertical: false
        )
        .readFrame(for: $infoViewFrame)
    }
    
    @ViewBuilder
    var favouriteApps: some View {
        if settings.favouriteApps.hasFavouriteApps, !isLandscape {
            AppView()
                .layoutPriority(-1)
                .frame(
                    minWidth: 0.0,
                    maxWidth: .infinity,
                    maxHeight: infoViewFrame.height
                )
                .fixedSize(
                    horizontal: false,
                    vertical: true
                )
        }
    }
    
    @ViewBuilder
    var weatherView: some View {
        if settings.weather.showWeather {
            WeatherView()
        }
    }
}
