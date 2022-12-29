//
//  StatusItemGroupView.swift
//  
//
//  Created by Noah Little on 28/12/2022.
//

import SwiftUI

// MARK: - Public

struct StatusItemGroupView: View {
    @StateObject private var chargingViewModel = ChargingIconViewModel()
    @StateObject private var lockIconViewModel = LockIconViewModel.shared
    
    var body: some View {
        HStack(spacing: 10.0) {
            lockIcon
            chargingIcon
            weatherView
        }
    }
}

// MARK: - Private

private extension StatusItemGroupView {
    var lockIcon: some View {
        StatusImage(
            image: Image(systemName: lockIconViewModel.lockImageName),
            color: Color(Colors.lockIconColor)
        )
    }
    
    @ViewBuilder
    var chargingIcon: some View {
        if PreferenceManager.shared.settings.hasChargingIndication,
           PreferenceManager.shared.settings.hasChargingIcon,
           chargingViewModel.isCharging {
            StatusImage(
                image: Image(systemName: chargingViewModel.imageName),
                color: chargingViewModel.indicationColor
            )
        }
    }
    
    @ViewBuilder
    var weatherView: some View {
        if PreferenceManager.shared.settings.showWeather {
            WeatherView()
        }
    }
}

// MARK: - Previews

struct StatusItemGroupView_Previews: PreviewProvider {
    static var previews: some View {
        StatusItemGroupView()
    }
}
