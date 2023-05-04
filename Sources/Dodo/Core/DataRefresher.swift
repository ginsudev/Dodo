//
//  DataRefresher.swift
//  
//
//  Created by Noah Little on 19/11/2022.
//

import UIKit.UIDevice
import DodoC
import Orion

final class DataRefresher {
    private lazy var alarmCache: MTAlarmCache? = {
        if let observer = SBScheduledAlarmObserver.sharedInstance() {
            let manager = Ivars<MTAlarmManager>(observer)._alarmManager
            return manager.cache
        } else {
            return nil
        }
    }()
}

// MARK: - Private

private extension DataRefresher {
    func refreshOnce() {
        // Update the weather
        if PreferenceManager.shared.settings.showWeather,
           PreferenceManager.shared.settings.isActiveWeatherAutomaticRefresh {
            NotificationCenter.default.post(name: .refreshOnceContent, object: nil)
        }
        
        // Charging indication
        if PreferenceManager.shared.settings.hasChargingFlash,
           UIDevice.current.batteryState != .unplugged {
            chargingIndication()
        }
        // Alarms
        updateAlarms()
    }
    
    func chargingIndication() {
        let chargeColor = UIDevice.current.batteryLevelColorRepresentation
        MediaPlayer.ViewModel.shared.temporarilySwapColor(chargeColor)
    }
    
    func updateAlarms() {
        if let cache = self.alarmCache,
           let orderedAlarms = cache.orderedAlarms as? [MTAlarm] {
            let alarms = orderedAlarms.compactMap { self.convertMobileAlarm($0) }
            DispatchQueue.main.async {
                AlarmTimerDataSource.shared.alarms = alarms
            }
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
