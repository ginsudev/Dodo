//
//  WeatherView.ViewModel.swift
//  
//
//  Created by Noah Little on 22/11/2022.
//

import Foundation
import DodoC
import GSWeather
import Combine
import CoreLocation

// MARK: - Internal

extension WeatherView {
    final class ViewModel: ObservableObject {
        enum Constants {
            static let minMinutesForRefresh = 30
        }
        
        private var bag: Set<AnyCancellable> = []
        
        @Published
        private var weather = PreferenceManager.shared.defaults.weather(forKey: Keys.cachedWeather)
        
        @Published
        private var location: CLLocation?
        
        @Published
        private(set) var locationName: String?
        
        @Published
        private var temperature: String?
        
        @Published
        var displayedString: String?
        
        @Published
        var conditionImageName: String?
        
        private let locationProvider: LocationProvider
        private let weatherProvider: WeatherProvider
                
        init() {
            self.locationProvider = .init()
            self.weatherProvider = .init()
            locationProvider.set(isUpdatingLocation: true)
            subscribe()
        }
        
        func updateWeather() {
            guard let location, canFetchWeather() else { return }
            weatherProvider.fetchWeather(provider: .meteo(
                location: location,
                unit: .current
            ))
        }
        
        func openWeatherApp() {
            AppsManager.shared.open(app: .defined(.weather))
            HapticManager.playHaptic(withIntensity: .custom(.medium))
        }
    }
}

// MARK: - Private

private extension WeatherView.ViewModel {
    typealias TemperatureUnit = WeatherProvider.TemperatureUnit
    
    func subscribe() {
        weatherProvider.currentWeather
            .receive(on: DispatchQueue.main)
            .compactMap { $0 }
            .assign(to: &$weather)
        
        $weather
            .compactMap { $0 }
            .sink { [weak self] in
                self?.temperature = "\(Int($0.temperature))\(TemperatureUnit.current.symbol)"
                self?.locationName = $0.placeName
            }
            .store(in: &bag)
        
        $weather
            .sink { PreferenceManager.shared.defaults.set(weather: $0, forKey: Keys.cachedWeather) }
            .store(in: &bag)
        
        locationProvider.location
            .assign(to: &$location)
        
        LocalState.shared.$isScreenOff
            .sink { [weak self] in self?.locationProvider.set(isUpdatingLocation: !$0) }
            .store(in: &bag)
        
        Publishers.CombineLatest($locationName, $temperature)
            .debounce(for: 0.5, scheduler: DispatchQueue.main)
            .compactMap { [$0, $1].compactMap { $0 } }
            .map { $0.joined(separator: " | ") }
            .assign(to: &$displayedString)
    }
    
    func canFetchWeather() -> Bool {
        guard let weather else { return true }
        let minutes = Calendar.current.dateComponents(
            [.minute],
            from: weather.date,
            to: Date()
        ).minute ?? .zero
        return minutes >= Constants.minMinutesForRefresh
    }
}
