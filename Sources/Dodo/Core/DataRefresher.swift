//
//  DataRefresher.swift
//  
//
//  Created by Noah Little on 19/11/2022.
//

import UIKit
import DodoC
import Orion

final class DataRefresher {
    private var timer = Timer()
    private var timerRunning = false
    
    private lazy var alarmCache: MTAlarmCache? = {
        if let observer = SBScheduledAlarmObserver.sharedInstance() {
            let manager = Ivars<MTAlarmManager>(observer)._alarmManager
            return manager.cache
        } else {
            return nil
        }
    }()
    
    init() {
        addObservers()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

// MARK: - Internal

extension DataRefresher {
    @objc func toggleTimer(notification: Notification) {
        if notification.name.rawValue == Notifications.nc_didDimLockScreen || notification.name.rawValue == Notifications.nc_didDismissLockScreen {
            toggleTimer(on: false)
        } else {
            toggleTimer(on: true)
        }
    }
    
    func toggleTimer(on enable: Bool) {
        // Do not start a timer for time/date updates because the user disabled Dodo's clock.
        guard PreferenceManager.shared.settings.timeMediaPlayerStyle != .mediaPlayer else {
            refreshOnce()
            return
        }
        // If `false` was passed in, invalidate the timer and return, don't start another timer.
        guard enable else {
            if self.timer.isValid {
                self.timer.invalidate()
                timerRunning = false
            }
            return
        }
        // Do not start a timer if one already exists.
        guard !self.timer.isValid else {
            return
        }
        // Safety checks passed, start timer.
        self.timer = Timer.scheduledTimer(
            timeInterval: 1,
            target: self,
            selector: #selector(refresh),
            userInfo: nil,
            repeats: true
        )
        // Fire the timer imediately (this happens once).
        self.timer.fire()
        // Update timer status.
        timerRunning = true
        // Update values that only need to be updated once.
        refreshOnce()
    }
}

// MARK: - Private

private extension DataRefresher {
    func addObservers() {
        // Screen turned on / lock screen became active.
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(toggleTimer(notification:)),
            name: NSNotification.Name(Notifications.nc_didUndimLockScreen),
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(toggleTimer(notification:)),
            name: NSNotification.Name(Notifications.nc_didPresentLockScreen),
            object: nil
        )
        // Screen turned off / lock screen was dismissed.
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(toggleTimer(notification:)),
            name: NSNotification.Name(Notifications.nc_didDimLockScreen),
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(toggleTimer(notification:)),
            name: NSNotification.Name(Notifications.nc_didDismissLockScreen),
            object: nil
        )
        // Dear AOD tweak devs, post this notification to update Dodo's time.
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(refresh),
            name: NSNotification.Name("Dodo.updateTimeAndDate"),
            object: nil
        )
    }
    
    @objc func refresh() {
        // Refresh time and date
        TimeDateView.ViewModel.shared.update(
            timeTemplate: PreferenceManager.shared.settings.timeTemplate,
            dateTemplate: PreferenceManager.shared.settings.dateTemplate
        )
    }
    
    func refreshOnce() {
        // Update the weather
        if PreferenceManager.shared.settings.showWeather && PreferenceManager.shared.settings.isActiveWeatherAutomaticRefresh {
            WeatherView.ViewModel.shared.updateWeather()
        }
        // Charging indication
        if PreferenceManager.shared.settings.hasChargingFlash && UIDevice.current.batteryState != .unplugged {
            chargingIndication()
        }
        // Alarms
        updateAlarms()
    }
    
    func chargingIndication() {
        let chargeColor = UIDevice.current.batteryLevelColorRepresentation()
        MediaPlayer.ViewModel.shared.temporarilySwapColor(chargeColor)
    }
    
    func updateAlarms() {
        if let cache = self.alarmCache,
           let nextAlarm = cache.nextAlarm {
            DispatchQueue.main.async { [weak self] in
                AlarmDataSource.shared.nextEnabledAlarm = self?.convertMobileTimer(nextAlarm)
            }
        }
    }
    
    func convertMobileTimer(_ alarm: MTAlarm) -> Alarm {
        Alarm(
            id: alarm.alarmID,
            url: alarm.alarmURL,
            nextFireDate: alarm.nextFireDate,
            displayTitle: alarm.displayTitle,
            isEnabled: alarm.isEnabled
        )
    }
}
