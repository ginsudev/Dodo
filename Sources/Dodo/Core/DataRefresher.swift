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
    private let darwinManager = DarwinNotificationsManager.sharedInstance()
    private var timer = Timer()
    
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
        darwinManager?.unregister(forNotificationName: Notifications.cf_lockScreenDidAppear)
        darwinManager?.unregister(forNotificationName: Notifications.cf_lockScreenDidDismiss)
    }
}

// MARK: - Private

private extension DataRefresher {
    func addObservers() {
        // Screen turned on / lock screen became active.
        darwinManager?.register(forNotificationName: Notifications.cf_lockScreenDidDismiss, callback: { [weak self] in
            self?.toggleTimer(on: false)
        })
        // Screen turned off / lock screen was dismissed.
        darwinManager?.register(forNotificationName: Notifications.cf_lockScreenDidAppear, callback: { [weak self] in
            self?.toggleTimer(on: true)
        })
        // Dear AOD tweak devs, post this notification to update Dodo's time.
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(refresh),
            name: NSNotification.Name("Dodo.updateTimeAndDate"),
            object: nil
        )
    }
    
    func toggleTimer(on enable: Bool) {
        Dimensions.shared.isVisibleLockScreen = enable
        
        // Do not start a timer for time/date updates because the user disabled Dodo's clock.
        guard PreferenceManager.shared.settings.timeMediaPlayerStyle != .mediaPlayer else {
            refreshOnce()
            return
        }
        
        // If `false` was passed in, invalidate the timer and return, don't start another timer.
        guard enable, !self.timer.isValid else {
            self.timer.invalidate()
            return
        }
        
        // Checks passed, start timer
        self.timer = Timer.scheduledTimer(
            timeInterval: 1,
            target: self,
            selector: #selector(self.refresh),
            userInfo: nil,
            repeats: true
        )

        // Add timer to the main run loop so it still works while the user is scrolling.
        RunLoop.main.add(self.timer, forMode: .common)
        self.timer.fire()

        // Refresh values that only need to be refreshed once.
        refreshOnce()
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
           let orderedAlarms = cache.orderedAlarms as? [MTAlarm] {
            let alarms = orderedAlarms.compactMap { self.convertMobileTimer($0) }
            DispatchQueue.main.async {
                AlarmDataSource.shared.alarms = alarms
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
