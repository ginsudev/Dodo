//
//  DataRefresher.swift
//  
//
//  Created by Noah Little on 19/11/2022.
//

import UIKit.UIDevice
import Combine
import DodoC
import Orion

final class DataRefresher {
    private let settings = PreferenceManager.shared.settings
    private var bag = Set<AnyCancellable>()
    
    private lazy var alarmCache: MTAlarmCache? = {
        if let observer = SBScheduledAlarmObserver.sharedInstance() {
            let manager = Ivars<MTAlarmManager>(observer)._alarmManager
            return manager.cache
        } else {
            return nil
        }
    }()
    
    init() {
        GlobalState.shared.$isVisibleLockScreen
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isVisibleLockScreen in
                guard let self, isVisibleLockScreen else { return }
                refreshOnce()
            }
            .store(in: &bag)
    }
}

// MARK: - Private

private extension DataRefresher {
    func refreshOnce() {
        // Update the weather
        if settings.weather.showWeather,
           settings.weather.showWeather.isActiveWeatherAutomaticRefresh {
            NotificationCenter.default.post(name: .refreshOnceContent, object: nil)
        }
        // Alarms
        updateAlarms()
    }
    
    func updateAlarms() {
        if let cache = self.alarmCache,
           let orderedAlarms = cache.orderedAlarms as? [MTAlarm] {
            let alarms = orderedAlarms.compactMap { self.convertMobileAlarm($0) }
            AlarmTimerDataSource.shared.alarms = alarms
        }
    }
    
    func convertMobileAlarm(_ alarm: MTAlarm) -> DDAlarm {
        .init(
            id: alarm.alarmID,
            url: alarm.alarmURL,
            nextFireDate: alarm.nextFireDate,
            displayTitle: alarm.displayTitle,
            isEnabled: alarm.isEnabled
        )
    }
}
