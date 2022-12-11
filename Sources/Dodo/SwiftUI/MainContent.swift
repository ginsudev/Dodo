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
            WeatherView()
        }
    }
    
    var midSection: some View {
        Group {
            if Settings.timeMediaPlayerStyle != .mediaPlayer {
                HStack {
                    TimeDateView()
                    Spacer()
                    if Settings.hasFavouriteApps {
                        AppView()
                            .frame(height: 40)
                    }
                }
            } else {
                Spacer()
                if Settings.hasFavouriteApps {
                    AppView()
                        .frame(height: 40)
                }
            }
        }
    }
}
