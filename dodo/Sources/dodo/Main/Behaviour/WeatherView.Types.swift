//
//  WeatherView.Types.swift
//  
//
//  Created by Noah Little on 25/6/2023.
//

import Foundation

extension WeatherView {
    enum TapAction: Int, CaseIterable {
        case none
        case refresh
        case celsiusToFahrenheit
        
        var title: String {
            switch self {
            case .none: return Copy.none
            case .refresh: return Copy.refresh
            case .celsiusToFahrenheit: return Copy.celsiusToFahrenheit
            }
        }
    }
}
