//
//  DataRefresher.swift
//  
//
//  Created by Noah Little on 19/11/2022.
//

import UIKit
import DodoC
import Orion

// MARK: - Public

final class DataRefresher {
    static let shared = DataRefresher()
    private let darwinManager = DarwinNotificationsManager.sharedInstance()
    private var timer = Timer()
    var timerRunning = false
    
    private lazy var alarmCache: MTAlarmCache? = {
        if let observer = SBScheduledAlarmObserver.sharedInstance() {
            let manager = Ivars<MTAlarmManager>(observer)._alarmManager
            return manager.cache
        } else {
            return nil
        }
    }()
    
    private init() {
        // Screen turned on / lock screen became active.
        darwinManager?.register(forNotificationName: "com.apple.springboardservices.eventobserver.internalSBSEventObserverEventContinuityUIWasObscured", callback: { [weak self] in
            self?.toggleTimer(on: false)
        })
        // Screen turned off / lock screen was dismissed.
        darwinManager?.register(forNotificationName: "com.apple.springboardservices.eventobserver.internalSBSEventObserverEventContinuityUIBecameVisible", callback: { [weak self] in
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
        let chargeColour = UIColor(red: 0.28, green: 0.57, blue: 0.18, alpha: 1.00)
        let prevColour = MediaPlayer.ViewModel.shared.artworkColour
        MediaPlayer.ViewModel.shared.artworkColour = chargeColour
       
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.8) {
            guard MediaPlayer.ViewModel.shared.artworkColour == chargeColour else {
                return
            }
            MediaPlayer.ViewModel.shared.artworkColour = prevColour
        }
    }
    
    func updateAlarms() {
        if let cache = alarmCache {
            var array = [Alarm]()
            for case let alarm as MTAlarm in Array(cache.orderedAlarms) {
                array.append(convertMobileTimer(alarm))
            }
            DispatchQueue.main.async {
                AlarmDataSource.shared.alarms = array
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
