//
//  MainContent.swift
//  
//
//  Created by Noah Little on 19/11/2022.
//

import SwiftUI

//MARK: - Public

struct MainContent: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 0.0) {
            topSection
            midSection
        }
    }
}

private extension MainContent {
    var topSection: some View {
        HStack(spacing: 0.0) {
            LockIcon()
            if PreferenceManager.shared.settings.showWeather {
                WeatherView()
            }
        }
    }
    
    var midSection: some View {
        Group {
            if PreferenceManager.shared.settings.timeMediaPlayerStyle != .mediaPlayer {
                HStack {
                    TimeDateView()
                    Spacer()
                    if PreferenceManager.shared.settings.hasFavouriteApps {
                        AppView()
                            .frame(height: 40)
                    }
                }
            } else {
                Spacer()
                if PreferenceManager.shared.settings.hasFavouriteApps {
                    AppView()
                        .frame(height: 40)
                }
            }
        }
    }
}
