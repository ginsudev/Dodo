//
//  WeatherView.ViewModel.swift
//  
//
//  Created by Noah Little on 22/11/2022.
//

import Foundation
import DodoC
import GSWeather
import GSCore
import Combine
import CoreLocation

// MARK: - Internal

extension WeatherView {
    final class ViewModel: ObservableObject {
        enum Constants {
            static let minMinutesForRefresh = 30
        }
        
        @Published
        private(set) var celsiusWeatherString: String?
        
        @Published
        private(set) var fahrenheitWeatherString: String?
        
        @Published
        private(set) var celsiusHighLowString: String?
        
        @Published
        private(set) var fahrenheitHighLowString: String?
        
        @Published
        private(set) var isDisplayingCelsius = true
        
        @Published
        private(set) var sunriseString: String?
        
        @Published
        private(set) var sunsetString: String?
        
        var weatherString: String? {
            guard let temp = isDisplayingCelsius ? celsiusWeatherString : fahrenheitWeatherString else { return nil }
            let highLow = isDisplayingCelsius ? celsiusHighLowString : fahrenheitHighLowString
            let result = [temp, highLow]
                .compactMap { $0 }
                .joined(separator: " ")
            return result
        }
        
        private var bag: Set<AnyCancellable> = []
        private var temperature = CurrentValueSubject<Temperature?, Never>(nil)
        private var high = CurrentValueSubject<Temperature?, Never>(nil)
        private var low = CurrentValueSubject<Temperature?, Never>(nil)
        private var location = CurrentValueSubject<CLLocation?, Never>(nil)
        private var weather = CurrentValueSubject<WeatherModel?, Never>(PreferenceManager.shared.defaults.weather(forKey: Keys.cachedWeather))
        
        private let locationProvider: LocationProvider
        private let weatherProvider: WeatherProvider
        private let settings = PreferenceManager.shared.settings.weather
        
        init() {
            self.locationProvider = .init()
            self.weatherProvider = .init()
            
            if settings.tapAction == .celsiusToFahrenheit {
                self.isDisplayingCelsius = PreferenceManager.shared.defaults.bool(forKey: Keys.isDisplayingCelsius)
            } else {
                self.isDisplayingCelsius = currentTemperatureUnit() == .celsius
            }
            
            locationProvider.set(isUpdatingLocation: true)
            subscribe()
        }
        
        func updateWeather() {
            guard canFetchWeather(), let location = location.value
            else { return }
            
            weatherProvider.fetchWeather(provider: .meteo(
                location: location,
                timezone: .current
            ))
        }
        
        func onTapWeather() {
            switch settings.tapAction {
            case .celsiusToFahrenheit:
                isDisplayingCelsius.toggle()
                HapticManager.playHaptic(withIntensity: .success)
            case .refresh:
                updateWeather()
                HapticManager.playHaptic(withIntensity: .success)
            case .none:
                break
            }
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
        // Store weather locally
        weatherProvider.currentWeatherPublisher
            .receive(on: DispatchQueue.main)
            .compactMap { $0 }
            .sink { [weak self] in self?.weather.send($0)}
            .store(in: &bag)
        
        // Store weather locally for display
        weather
            .compactMap { model -> (celsius: String, fahrenheit: String)? in
                guard let name = model?.locationName,
                      let temperature = model?.temperature
                else { return nil }
                return (
                    "\(name) | \(temperature.celsius)",
                    "\(name) | \(temperature.fahrenheit)"
                )
            }
            .sink { [weak self] celsius, fahrenheit in
                self?.celsiusWeatherString = celsius
                self?.fahrenheitWeatherString = fahrenheit
            }
            .store(in: &bag)
        
        // Store high/low locally for display
        if settings.isVisibleHighLow {
            weather
                .compactMap { [weak self] model -> (celsius: String, fahrenheit: String)? in
                    guard let self,
                          let high = model?.high,
                          let low = model?.low
                    else { return nil }
                    
                    return (
                        highLowStringBuilder(high: high, low: low, isCelsius: true),
                        highLowStringBuilder(high: high, low: low, isCelsius: false)
                    )
                }
                .sink { [weak self] celsius, fahrenheit in
                    self?.celsiusHighLowString = celsius
                    self?.fahrenheitHighLowString = fahrenheit
                }
                .store(in: &bag)
        }
        
        if settings.isVisibleSunriseSunset {
            weather
                .compactMap { model -> (sunrise: String, sunset: String)? in
                    guard let model else { return nil }
                    return (
                        Formatters.time.string(from: model.sunrise),
                        Formatters.time.string(from: model.sunset)
                    )
                }
                .sink { [weak self] sunrise, sunset in
                    self?.sunriseString = sunrise
                    self?.sunsetString = sunset
                }
                .store(in: &bag)
        }
        
        // Enable/Disable location monitoring depending on screen on state
        LocalState.shared.$isScreenOff
            .sink { [weak self] in self?.locationProvider.set(isUpdatingLocation: !$0) }
            .store(in: &bag)
        
        // Store location locally
        locationProvider.locationPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in self?.location.send($0)}
            .store(in: &bag)
        
        // Caching
        weather
            .sink { PreferenceManager.shared.defaults.set(weather: $0, forKey: Keys.cachedWeather) }
            .store(in: &bag)
        
        $isDisplayingCelsius
            .sink { PreferenceManager.shared.defaults.set($0, forKey: Keys.isDisplayingCelsius) }
            .store(in: &bag)
    }
    
    func canFetchWeather() -> Bool {
        guard let weather = weather.value else { return true }
        let minutes = Calendar.current.dateComponents(
            [.minute],
            from: weather.date,
            to: Date()
        ).minute ?? .zero
        return minutes >= Constants.minMinutesForRefresh
    }
    
    func currentTemperatureUnit() -> TemperatureUnit? {
        guard let provider = WeatherService.shared()?.temperatureUnitProvider else { return nil }
        
        switch provider.userTemperatureUnit {
        case 2: return .celsius
        case 1: return .fahrenheit
        default: return nil
        }
    }
    
    func highLowStringBuilder(high: Temperature, low: Temperature, isCelsius: Bool) -> String {
        let highTemp = isCelsius ? high.celsius : high.fahrenheit
        let lowTemp = isCelsius ? low.celsius : low.fahrenheit
        return Copy.Weather.highLow(highTemp, lowTemp)
    }
}
