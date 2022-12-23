//
//  MainContent.swift
//  
//
//  Created by Noah Little on 19/11/2022.
//

import SwiftUI

//MARK: - Public

struct MainContent: View {
    @StateObject private var chargingViewModel = ChargingIcon.ViewModel()
    @EnvironmentObject var dimensions: Dimensions
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0.0) {
            topSection
            midSection
        }
    }
}

private extension MainContent {
    var topSection: some View {
        HStack(spacing: 10.0) {
            LockIcon()
            chargingIcon
            if PreferenceManager.shared.settings.showWeather {
                WeatherView()
            }
        }
    }
    
    @ViewBuilder
    var midSection: some View {
        if PreferenceManager.shared.settings.timeMediaPlayerStyle == .mediaPlayer {
            Spacer()
            if PreferenceManager.shared.settings.hasFavouriteApps, !dimensions.isLandscape {
                AppView()
                    .frame(height: 40)
            }
        } else {
            HStack {
                TimeDateView()
                Spacer()
                if PreferenceManager.shared.settings.hasFavouriteApps, !dimensions.isLandscape {
                    AppView()
                        .frame(height: 40)
                }
            }
        }
    }
    
    @ViewBuilder
    var chargingIcon: some View {
        if PreferenceManager.shared.settings.hasChargingIndication,
           PreferenceManager.shared.settings.hasChargingIcon,
           chargingViewModel.isCharging {
            ChargingIcon()
                .environmentObject(chargingViewModel)
        }
    }
}
