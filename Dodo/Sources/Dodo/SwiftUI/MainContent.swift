//
//  MainContent.swift
//  
//
//  Created by Noah Little on 19/11/2022.
//

import SwiftUI

// MARK: - Public

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
        .fixedSize(horizontal: false, vertical: true)
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
    }
    
    @ViewBuilder
    var favouriteApps: some View {
        if settings.favouriteApps.hasFavouriteApps, !isLandscape {
            AppView()
                .layoutPriority(-1)
                .frame(minHeight: 0, idealHeight: 0, maxHeight: .infinity)
        }
    }
    
    @ViewBuilder
    var weatherView: some View {
        EmptyView()
//        if settings.weather.showWeather {
//            WeatherView()
//        }
    }
}
