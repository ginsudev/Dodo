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
    private var bag = Set<AnyCancellable>()
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
        subscribe()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

// MARK: - Private

private extension DataRefresher {
    func subscribe() {
        // Screen turned on / lock screen became active.
        NotificationCenter.default.publisher(for: .didAppearLockScreen)
            .sink { [weak self] _ in
                self?.toggleTimer(on: true)
            }
            .store(in: &bag)
        
        // Screen turned off / lock screen was dismissed.
        NotificationCenter.default.publisher(for: .didDismissLockScreen)
            .sink { [weak self] _ in
                self?.toggleTimer(on: false)
            }
            .store(in: &bag)
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
        NotificationCenter.default.post(name: .refreshContent, object: nil)
    }
    
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
