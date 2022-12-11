//
//  WeatherView.ViewModel.swift
//  
//
//  Created by Noah Little on 22/11/2022.
//

import DodoC

extension WeatherView {
    enum TemperatureUnit: Int {
    case celsius = 0,
         fahrenheit = 1,
         kelvin = 2
    }
    
    final class ViewModel: ObservableObject {
        @Published var locationName = ""
        @Published var temperature = ""
        @Published var conditionImage = UIImage(systemName: "xmark.icloud")!
        
        static let shared = ViewModel()
        
        func updateWeather(forced: Bool) {
            GSWeather.sharedInstance().update(forced)
            DispatchQueue.main.async {
                self.temperature = GSWeather.sharedInstance().temperature()
                self.locationName = GSWeather.sharedInstance().locationName()
                self.conditionImage = GSWeather.sharedInstance().conditionImage()
            }
        }
    }
}
