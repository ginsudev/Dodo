//
//  MainContent.swift
//  
//
//  Created by Noah Little on 19/11/2022.
//

import SwiftUI

//MARK: - Public

struct MainContent: View {
    @EnvironmentObject var dimensions: Dimensions
    @State private var infoViewFrame: CGRect = .zero
    
    var body: some View {
        HStack(spacing: 0) {
            infoView
                .layoutPriority(1)
            favouriteApps
                .frame(
                    minWidth: 0,
                    maxWidth: UIScreen.main.bounds.width - infoViewFrame.width,
                    maxHeight: infoViewFrame.height
                )
                .layoutPriority(-1)
        }
    }
}

private extension MainContent {
    @ViewBuilder
    var infoView: some View {
        VStack(alignment: .leading, spacing: 5.0) {
            weatherView
            TimeDateView()
        }
        .fixedSize()
        .readFrame(for: $infoViewFrame)
    }
    
    @ViewBuilder
    var favouriteApps: some View {
        if PreferenceManager.shared.settings.hasFavouriteApps, !dimensions.isLandscape {
            AppView()
                .fixedSize(horizontal: false, vertical: true)
        }
    }
    
    @ViewBuilder
    var weatherView: some View {
        if PreferenceManager.shared.settings.showWeather {
            WeatherView()
        }
    }
}
