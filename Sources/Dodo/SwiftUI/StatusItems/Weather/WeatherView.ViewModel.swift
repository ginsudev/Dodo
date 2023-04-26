//
//  WeatherView.ViewModel.swift
//  
//
//  Created by Noah Little on 22/11/2022.
//

import DodoC

extension WeatherView {
    final class ViewModel: ObservableObject {
        @Published private(set) var locationName = ""
        @Published private(set) var temperature = ""
        @Published private(set) var conditionImage = UIImage(systemName: "xmark.icloud")!
        
        static let shared = ViewModel()
        
        func updateWeather() {
#if ROOTFUL
            PDDokdo.sharedInstance().refreshWeatherData()
            DispatchQueue.main.async { [weak self] in
                self?.temperature = PDDokdo.sharedInstance().currentTemperature ?? ""
                self?.locationName = PDDokdo.sharedInstance().currentLocation ?? ""
                self?.conditionImage = PDDokdo.sharedInstance().currentConditionsImage ?? UIImage(systemName: "xmark.icloud")!
            }
#endif
        }
        
        func openWeatherApp() {
            AppsManager.shared.open(app: .defined(.weather))
            HapticManager.playHaptic(withIntensity: .custom(.medium))
        }
    }
}
